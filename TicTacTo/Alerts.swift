//
//  Alerts.swift
//  TicTacTo
//
//  Created by Juma on 5/3/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin             = AlertItem(title: Text("You win!"),
                                                message: Text("You god dam right son!"),
                                                buttonTitle: Text("Hell yeah"))
    static let computerWin          = AlertItem(title: Text("You lost"),
                                                message: Text("You programed super AI!"),
                                                buttonTitle: Text("Rematch"))
    static let draw                 = AlertItem(title: Text("Draw"),
                                                message: Text("This was a hell of a ride son!"),
                                                buttonTitle: Text("Try again"))
}


