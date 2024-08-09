//
//  WxLiveGiftPlayerApp.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/6.
//

import SwiftUI

@main
struct WxLiveGiftPlayerApp: App {
    
    init() {
        WxLiveServer.shared.configServer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
