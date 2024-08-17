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
//    @State private var showAlert = false
    
    @StateObject var backgroundMusicPlayer = BackgroundMusicPlayer.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    DebugKit.config()
                    
                    configServer()
                    playBgm()
                    configRtmp()
                    startRtmp()
//                    startLive()
                }
                .onDisappear {
                    stopBgm()
                    stopRtmp()
                }
//                .alert(isPresented: $showAlert) {
//                    Alert(
//                        title: Text(serverURL),
//                        message: Text("")
//                    )
//                }
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
//            showAlert = true
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
        livePush.startRtmp()
    }
    func stopRtmp() {
        livePush.stopRtmp()
    }
}

extension WxLiveGiftPlayerApp {
    
    func startLive() {
        let tt = UIView(frame: CGRect(x: 20, y: 50, width: 100, height: 100))
        tt.backgroundColor = .red
        AlertUtil.topVC?.view.addSubview(tt)
        livePush.startLive(view: tt)
    }
}
