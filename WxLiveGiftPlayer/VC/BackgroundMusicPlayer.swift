//
//  BackgroundMusicPlayer.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/12.
//

import AVFoundation

class BackgroundMusicPlayer: ObservableObject {
    static let shared: BackgroundMusicPlayer = {
        let instance = BackgroundMusicPlayer()
        instance.setupAudioSession()
        return instance
    }()
    private var audioPlayer: AVAudioPlayer?
    
    // 设置 AVAudioSession
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
        } catch {
            mylog("Failed to set up audio session: \(error.localizedDescription)", toast: false)
        }
    }
    
    /// 处理音频中断
    @objc private func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
            case .began:
                // 音频中断开始，暂停播放
                stopPlaying()
            case .ended:
                // 音频中断结束，恢复播放
                if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                    let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                    if options.contains(.shouldResume) {
                        startPlaying()
                    }
                }
            default:
                break
        }
    }

    func startPlaying() {
        guard let path = Bundle.main.path(forResource: "undead funeral march.mp3", ofType: nil) else {
            print("Background music file not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.numberOfLoops = -1 // 循环播放
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Failed to create audio player: \(error.localizedDescription)")
        }
    }

    func stopPlaying() {
        audioPlayer?.stop()
    }
}
