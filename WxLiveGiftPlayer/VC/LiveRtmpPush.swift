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
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), useCapture: false)
    }
    
    func configReplay() {
        // 配置推流参数
        rtmpStream.videoSettings = .init(videoSize: CGSize(width: 720, height: 1280), profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel as String, bitRate: 1600 * 1000)
        var audioSettings = AudioCodecSettings.default
        audioSettings.bitRate = 64 * 1000 // 64 kbps
        rtmpStream.audioSettings = audioSettings
        
        addRtmpStateNotify()

//        rtmpConnection.connect("rtmp://111583.livepush.myqcloud.com/trtc_1400439699/live_2078715825641529355?txSecret=5053dab6698161f7f87f907920a981dc&txTime=66BF2CDC")
//        rtmpConnection.connect("rtmp://111583.livepush.myqcloud.com/trtc_1400439699/live_2078715885249449999?txSecret=1016744715798f241006bacd644d4fe9&txTime=66BF65B5")
        rtmpConnection.connect("rtmp://111583.livepush.myqcloud.com/trtc_1400439699/")
        rtmpStream.publish("live_2078715885249449999?txSecret=1016744715798f241006bacd644d4fe9&txTime=66BF65B5")
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
                mylog("捕获失败：\(error)")
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
                mylog("捕获开启失败：\(error)")
            }
        }
    }
    
    func stopCapture() {
        recorder.stopCapture { (error) in
            if let error = error {
                mylog("捕获停止失败：\(error)")
            }
        }

        rtmpStream.close()
        rtmpConnection.close()
    }

}

extension LiveRtmpPush {
    func addRtmpStateNotify() {
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self, useCapture: false)
    }
    
    @objc func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            mylog("RTMP 连接成功")
        case RTMPConnection.Code.connectFailed.rawValue,
             RTMPConnection.Code.connectClosed.rawValue:
            mylog("RTMP 连接失败或者关闭")
        default:
            break
        }
    }
}
