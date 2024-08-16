//
//  LiveRtmpPush.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/14.
//

import ReplayKit
import HaishinKit
import VideoToolbox
import LFLiveKit

class LiveRtmpPush: NSObject {
    
    static let shared = LiveRtmpPush()
    
    var rtmpURL = "rtmp://111583.livepush.myqcloud.com/trtc_1400439699/"
    var rtmpSecret = "live_2078716458998485101?txSecret=c642912ecf97864152d1eebb1827cb5d&txTime=66C188E0"
    var rtmpOpen = false
    var captureOpen = false
    
    private lazy var recorder: RPScreenRecorder = {
        let shared = RPScreenRecorder.shared()
        shared.delegate = self
        return shared
    }()
    private let rtmpConnection = RTMPConnection()
    private lazy var rtmpStream = RTMPStream(connection: rtmpConnection)
    
    
    
    //MARK: - Getters and Setters
    lazy var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: .low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
            
        session?.delegate = self
        return session!
    }()
    
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
        rtmpStream.append(sampleBuffer)
    }
    
    func handleAudioSampleBuffer(_ sampleBuffer: CMSampleBuffer) {
        rtmpStream.append(sampleBuffer)
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
        rtmpStream.videoSettings.bitRate = 2000 * 1000
//        rtmpStream.videoSettings.allowFrameReordering = true
//        rtmpStream.videoSettings.frameInterval = 0.01
//        rtmpStream.videoSettings.maxKeyFrameIntervalDuration = Int32(0.1)
//        rtmpStream.videoSettings.bitRateMode = .constant
        rtmpStream.videoSettings.profileLevel = kVTProfileLevel_HEVC_Main_AutoLevel as String
        
        rtmpStream.publish(rtmpSecret)
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


extension LiveRtmpPush: LFLiveSessionDelegate {

    func startLive(view: UIView) -> Void {
        session.preView = view
        let stream = LFLiveStreamInfo()
        stream.url = "your server rtmp url";
        session.startLive(stream)
    }

    func stopLive() -> Void {
        session.stopLive()
    }
    
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        mylog(#function, debugInfo)
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        mylog(#function, errorCode.rawValue)
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        mylog(#function, state)
    }
}
