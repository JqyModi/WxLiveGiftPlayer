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
    
    let livePush = LiveRtmpPush.shared
    
    @State var serverURL: String = ""
    @State private var showAlert = false
    
    @StateObject var backgroundMusicPlayer = BackgroundMusicPlayer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    configServer()
                    playBgm()
                    configRtmp()
                    startRtmp()
                }
                .onDisappear {
                    stopBgm()
                    stopRtmp()
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

extension WxLiveGiftPlayerApp {
    func configRtmp() {
        livePush.configReplay()
    }
    func startRtmp() {
        livePush.startCapture()
    }
    func stopRtmp() {
        livePush.stopCapture()
    }
}
