//
//  GameViewModel.swift
//  TicTacTo
//
//  Created by Juma on 5/3/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        if isSquareAccupid(in: moves, forIndex: position) {return}
        moves[position] = Move(player: .human, boardIndex: position)
        
        
        //MARK: - check for win condition or draw
        
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkDraw(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameBoardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let computerPosition = determineComputerMovePosition(in:  moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameBoardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkDraw(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
    }
    
    
    func isSquareAccupid(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index})
    }
    /*
     1. if AI can win, then win
     2. if AI can't win, then block
     3. if AI can't block, then take middle square
     4. if AI can't take middle square, take random available square
     */
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        //if AI can win, then win
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8]
                                         ,[0,4,8],[2,4,6]]
        let computerMoves = moves.compactMap {$0}.filter {$0.player == .computer}
        let computerPositions = Set(computerMoves.map {$0.boardIndex})
        
        for patern in winPattern {
            let winPositions = patern.subtracting(computerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareAccupid(in: moves, forIndex: winPositions.first!)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        //if AI can't win, then block
        
        let humanMoves = moves.compactMap {$0}.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map {$0.boardIndex})
        
        for patern in winPattern {
            let winPositions = patern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareAccupid(in: moves, forIndex: winPositions.first!)
                if isAvailable {
                    return winPositions.first!
                }
            }
        }
        
        //if AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareAccupid(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        //if AI can't take middle square, take random available square
         
        
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareAccupid(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPattern: Set<Set<Int>> = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8]
                                         ,[0,4,8],[2,4,6]]
        
        let playerMoves = moves.compactMap {$0}.filter {$0.player == player}
        let playerPositions = Set(playerMoves.map {$0.boardIndex})
        
        for patern in winPattern where patern.isSubset(of: playerPositions) { return true}
        
        return false
    }
    
    func checkDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }

}
