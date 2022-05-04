//
//  GameView.swift
//  TicTacTo
//
//  Created by Juma on 5/3/22.
//

import SwiftUI



struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader{ geomtry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack{
                            GameSquareView(proxy: geomtry)
                            PlayerIndicador(systemImageName: viewModel.moves[i]?.indicator ?? "")
                            
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                }
                
                Spacer()
            }
            .disabled(viewModel.isGameBoardDisabled)
            .padding()
            .alert(item: $viewModel.alertItem, content: { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: { viewModel.resetGame()}))
            })
        }
    }
    
   }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct GameSquareView: View {
    var proxy: GeometryProxy
    var body: some View {
        Circle()
            .foregroundColor(.blue)
            .opacity(0.5)
            .frame(width: proxy.size.width/3-15,
                   height: proxy.size.width/3-15)
    }
}

struct PlayerIndicador: View {
    var systemImageName: String
    var body: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
    }
}
