//
//  LiveRtmpPush.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/14.
//

import ReplayKit
import HaishinKit
import VideoToolbox

class LiveRtmpPush {
    
    static let shared = LiveRtmpPush()
    
    private let recorder = RPScreenRecorder.shared()
    private let rtmpConnection = RTMPConnection()
    private lazy var rtmpStream = RTMPStream(connection: rtmpConnection)
    
    deinit {
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler))
    }
    
    func configReplay() {
        // 配置推流参数
        rtmpStream.videoSettings = .init(videoSize: CGSize(width: 720, height: 1280), profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel as String, bitRate: 1600 * 1000)
        var audioSettings = AudioCodecSettings.default
        audioSettings.bitRate = 64 * 1000 // 64 kbps
        rtmpStream.audioSettings = audioSettings
        
        addRtmpStateNotify()

        rtmpConnection.connect("rtmp://111583.livepush.myqcloud.com/trtc_1400439699/live_2078715825641529355?txSecret=5053dab6698161f7f87f907920a981dc&txTime=66BF2CDC")
        rtmpStream.publish("streamName")
    }
    
    func handleVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
//        rtmpStream.append(sampleBuffer)
        rtmpStream.appendSampleBuffer(sampleBuffer)
    }
    
    func handleAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
//        rtmpStream.append(sampleBuffer)
        rtmpStream.appendSampleBuffer(sampleBuffer)
    }
    
    func startCapture() {
        // 开始捕捉屏幕和音频
        recorder.startCapture(handler: { (sampleBuffer, bufferType, error) in
            if let error = error {
                print("Capture failed: \(error)")
                return
            }

            switch bufferType {
            case .video:
                self.handleVideoSampleBuffer(sampleBuffer)
            case .audioApp, .audioMic:
                self.handleAudioSampleBuffer(sampleBuffer)
            @unknown default:
                break
            }
        }) { (error) in
            if let error = error {
                print("Capture failed to start: \(error)")
            }
        }
    }
    
    func stopCapture() {
        recorder.stopCapture { (error) in
            if let error = error {
                print("Stop capture failed: \(error)")
            }
        }

        rtmpStream.close()
        rtmpConnection.close()
    }

}

extension LiveRtmpPush {
    func addRtmpStateNotify() {
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self, useCapture: true)
    }
    
    @objc func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            print("RTMP Connected")
        case RTMPConnection.Code.connectFailed.rawValue,
             RTMPConnection.Code.connectClosed.rawValue:
            print("RTMP Connection Failed/Closed")
        default:
            break
        }
    }
}
