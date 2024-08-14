//
//  DebugKit.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/14.
//

import DoraemonKit
import SwiftUI

struct DebugKit {
    static func config() {
        DoraemonManager.shareInstance().install()
        
        DoraemonManager.shareInstance().addPlugin(withTitle: "RTMP配置", icon: "doraemon_cpu", desc: "", pluginName: "RTMPConfig", atModule: "自定义") { dict in
            DoraemonManager.shareInstance().hiddenHomeWindow()
            
            let rtmpVC = UIHostingController(rootView: RtmpConfigView())
            let view = RtmpConfigView(vc: rtmpVC)
            rtmpVC.rootView = view
//            view.tapConfirm = {_ in
//                rtmpVC.dismiss(animated: true)
//            }
            AlertUtil.topVC?.present(rtmpVC, animated: true)
        }
    }
}
