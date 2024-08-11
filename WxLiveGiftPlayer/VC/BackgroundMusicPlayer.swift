//
//  BackgroundMusicPlayer.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/12.
//

import AVFoundation

class BackgroundMusicPlayer: ObservableObject {
    static let shared = BackgroundMusicPlayer()
    private var audioPlayer: AVAudioPlayer?

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
