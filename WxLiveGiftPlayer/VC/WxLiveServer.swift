//
//  WxLiveServer.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/8.
//

import Foundation
import GCDWebServer

class WxLiveServer {
    
    static let shared = WxLiveServer()
    
    let server = GCDWebServer()
    
    func configServer() {
        server.addHandler(forMethod: "POST", path: "/forward", request: GCDWebServerDataRequest.self) { request, data  in
            
            if let request = request as? GCDWebServerDataRequest {
                print("接收到弹幕数据: ", request.jsonObject as Any)
                self.handleRequestData(request: request)
            }
            
//            let resp = GCDWebServerResponse(redirect: URL(string: "https://www.baidu.com/")!, permanent: true)
//            data(resp)
            
            let resp1 = GCDWebServerDataResponse(text: "请求成功")
            resp1?.statusCode = 200
            data(resp1)
        }
        server.start(withPort: 8081, bonjourName: "你好")
        
        let serverURL = server.serverURL
        print("服务已经启动URL：", serverURL as Any)
    }
    
}

extension WxLiveServer {
    func handleRequestData(request: GCDWebServerRequest) {
        switch request {
            case let tt as GCDWebServerDataRequest:
                let json = tt.jsonObject as? NSDictionary
                let sec_gift_id = (json?.value(forKeyPath: "events.sec_gift_id") as? Array<String>)?.first as? String ?? ""
                let msg_sub_type = (json?.value(forKeyPath: "events.msg_sub_type") as? Array<String>)?.first as? String ?? ""
                let decoded_type = (json?.value(forKeyPath: "events.decoded_type") as? Array<String>)?.first as? String ?? ""
                if !decoded_type.contains("gift")  {
                    print("礼物消息")
                    // 发送消息告诉SwiftUI播放礼物动效
                    NotificationCenter.default.post(name: NSNotification.Name("playPagEffects"), object: nil)
                } else {
                    print("非礼物消息")
                }
            default:
                break
        }
    }
}
