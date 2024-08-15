//
//  LiveRtmpPush.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/14.
//

import ReplayKit
import HaishinKit
import VideoToolbox

class LiveRtmpPush: NSObject {
    
    static let shared = LiveRtmpPush()
    
    var rtmpURL = "rtmp://111583.livepush.myqcloud.com/trtc_1400439699/"
    var rtmpSecret = "live_2078715885249449999?txSecret=1016744715798f241006bacd644d4fe9&txTime=66BF65B5"
    var rtmpSecret1 = "live_2078716103325302910?txSecret=9092cba890306f44ebb92abf52d22584&txTime=66C035AE"
    var rtmpOpen = false
    var captureOpen = false
    
    private lazy var recorder: RPScreenRecorder = {
        let shared = RPScreenRecorder.shared()
        shared.delegate = self
        return shared
    }()
    private let rtmpConnection = RTMPConnection()
    private lazy var rtmpStream = RTMPStream(connection: rtmpConnection)
    
    deinit {
        rtmpConnection.removeEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), useCapture: false)
        NotificationCenter.default.removeObserver(self)
    }
    
    func configReplay() {
        addRtmpStateNotify()
    }
    
    func handleVideoSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
//        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
//            return
//        }
        rtmpStream.appendSampleBuffer(sampleBuffer)
    }
    
    func handleAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        rtmpStream.appendSampleBuffer(sampleBuffer)
    }
    
    func startRtmp() {
        if rtmpOpen {
            if !captureOpen {
                startCapture()
            }
            return
        }
        
        if !captureOpen {
            startCapture()
        }
        
        rtmpConnection.connect(rtmpURL)
        configRtmpStream()
    }
    
    func configRtmpStream() {
        rtmpStream = RTMPStream(connection: rtmpConnection)
        // 配置推流参数
//        rtmpStream.videoSettings = .init(videoSize: CGSize(width: 720, height: 1280), profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel as String, bitRate: 1600 * 1000)
//        var audioSettings = AudioCodecSettings.default
//        audioSettings.bitRate = 64 * 1000 // 64 kbps
//        rtmpStream.audioSettings = audioSettings
        
        rtmpStream.videoSettings.videoSize = CGSize(width: 720, height: 1280)
        
        rtmpStream.publish(rtmpSecret1)
    }
    
    func stopRtmp() {
        if !rtmpOpen {
            return
        }
        
        rtmpStream.close()
        rtmpConnection.close()
        
        rtmpOpen = false
    }
    
    func startCapture() {
        if captureOpen {
            return
        }
        
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
                self.captureOpen = false
            }
            self.captureOpen = true
        }
    }
    
    func stopCapture() {
        if !captureOpen {
            return
        }
        
        recorder.stopCapture { (error) in
            if let error = error {
                mylog("捕获停止失败：\(error)")
            }
            self.captureOpen = false
        }
    }

}

extension LiveRtmpPush {
    func addRtmpStateNotify() {
        rtmpConnection.addEventListener(.rtmpStatus, selector: #selector(rtmpStatusHandler), observer: self, useCapture: false)
        
        NotificationCenter.default.addObserver(forName: .startRtmp, object: nil, queue: nil) { notify in
            self.startRtmp()
        }
        
        NotificationCenter.default.addObserver(forName: .stopRtmp, object: nil, queue: nil) { notify in
            self.stopRtmp()
        }
    }
    
    @objc func rtmpStatusHandler(_ notification: Notification) {
        let e = Event.from(notification)
        
        guard let data: ASObject = e.data as? ASObject, let code: String = data["code"] as? String else {
            return
        }
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            mylog("RTMP 连接成功")
            self.rtmpOpen = true
        case RTMPConnection.Code.connectFailed.rawValue,
             RTMPConnection.Code.connectClosed.rawValue:
            mylog("RTMP 连接失败或者关闭")
            self.rtmpOpen = false
        default:
            break
        }
    }
}

extension LiveRtmpPush: RPScreenRecorderDelegate {
    func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        mylog(#function, screenRecorder.isAvailable)
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        mylog("停止屏幕录制", previewViewController, error as Any)
    }
    
    func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWithError error: Error, previewViewController: RPPreviewViewController?) {
        mylog("停止屏幕录制", previewViewController as Any, error)
    }
}
