//
//  WxLiveGiftPlayerApp.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/6.
//

import SwiftUI
import GCDWebServer

@main
struct WxLiveGiftPlayerApp: App {
    
    @State var serverURL: String = ""
    @State private var showAlert = false
    
    @StateObject var backgroundMusicPlayer = BackgroundMusicPlayer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    configServer()
                    playBgm()
                }
                .onDisappear {
                    stopBgm()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text(serverURL),
                        message: Text("")
                    )
                }
        }
    }
}

extension WxLiveGiftPlayerApp {
    func configServer() {
        WxLiveServer.shared.configServer { server in
            guard let server = server as? GCDWebServer else {
                return
            }
            
            serverURL = server.serverURL?.absoluteString ?? ""
            showAlert = true
        }
    }
    
    func playBgm() {
        backgroundMusicPlayer.startPlaying()
    }
    
    func stopBgm() {
        backgroundMusicPlayer.stopPlaying()
    }
}
