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

/// iOS直播屏幕共享方案
/// https://forasoft.medium.com/how-to-implement-screen-sharing-in-ios-app-using-replaykit-and-app-extension-eea7094cebf4
/// 低延时100ms方案
/// https://www.youtube.com/watch?v=wMGfYtytAEc

class LiveRtmpPush: NSObject {
    
    static let shared = LiveRtmpPush()
    
    var rtmpURL = "rtmp://111583.livepush.myqcloud.com/trtc_1400439699/"
    var rtmpSecret = "live_2078716942913486890?txSecret=ba405d31130fdb564d3271f656bd263b&txTime=66C35660"
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
        session?.running = true
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
//        var audioSettings = AudioCodecSettings.default
//        audioSettings.bitRate = 64 * 1000 // 64 kbps
//        rtmpStream.audioSettings = audioSettings
        
//        rtmpStream.sessionPreset = .high
//        rtmpStream.frameRate = 30
        rtmpStream.frameRate = 60
//        rtmpStream.frameRate = 30
        
//        rtmpStream.videoSettings.profileLevel = kVTProfileLevel_H264_Main_AutoLevel as String
//        rtmpStream.videoSettings.bitRate = 1200 * 1000
//        rtmpStream.videoSettings.videoSize = CGSizeMake(720, 1280)
        rtmpStream.videoSettings = .init(
//            videoSize: CGSizeMake(720, 1280),
            videoSize: CGSizeMake(1080, 2048),
//            videoSize: CGSizeMake(2160, 3840),
//                                         bitRate: 4000 * 1000, // 1K = 720P
                                         bitRate: 8000 * 1000, // 2K
//                                         bitRate: 40000 * 1000, // 4K
                                         profileLevel: kVTProfileLevel_H264_High_AutoLevel as String,
                                         scalingMode: .trim,
                                         bitRateMode: .constant,
                                         maxKeyFrameIntervalDuration: 2,
                                         allowFrameReordering: false)
        
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
        stream.url = rtmpURL + rtmpSecret
//        stream.streamId = rtmpSecret
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
