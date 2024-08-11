//
//  WxLiveServer.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/8.
//

import Foundation
import GCDWebServer
import SwiftUI

class WxLiveServer {
    
    static let shared = WxLiveServer()
    
    let server = GCDWebServer()
    
    func configServer(completion: ValueAction) {
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
        // 调用AlertUtil类显示alert
//        AlertUtil.showAlert(title: "服务已经启动", message: "URL：\(serverURL?.absoluteString ?? "")")
        
        completion(server)
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
                let content = (json?.value(forKeyPath: "events.content") as? Array<String>)?.first as? String ?? ""
                if decoded_type.contains("gift")  {
                    print("礼物消息")
                    // 发送消息告诉SwiftUI播放礼物动效
                    
                    guard let giftName = extractGiftName(from: content) else {
                        print("No gift name found.")
                        return
                    }
                    
                    print("Gift name: \(giftName)") // 应该输出：Gift name: 爱心
                    
                    NotificationCenter.default.post(name: NSNotification.Name("playPagEffects"), object: nil, userInfo: ["giftName": giftName])
                } else {
                    print("非礼物消息")
                }
            default:
                break
        }
    }

    func extractGiftName(from content: String) -> String? {
        let regexPattern = "(\\d+个)([\\u4e00-\\u9fa5]+)" // 匹配数字和“个”，后面跟中文字符

        do {
            let regex = try NSRegularExpression(pattern: regexPattern, options: [])
            let nsRange = NSRange(content.startIndex..<content.endIndex, in: content)
            let matches = regex.matches(in: content, options: [], range: nsRange)

            if let match = matches.first {
                let giftNameRange = match.range(at: 2)
                if let range = Range(giftNameRange, in: content) {
                    return String(content[range])
                }
            }
        } catch {
            print("Invalid regex: \(error.localizedDescription)")
        }
        return nil
    }
}

extension WxLiveServer {
    static func testGiftMsg() {
        let giftMsg = """
                curl -X POST -H "Content-Type: application/json" -d '{
                "host_info": {
                  "wechat_uin": "3586779100",
                  "finder_username": "v2_060000231003b20faec8c4e08918c1d4c605ed3cb077137cfca22f8db6f2d338c86e6ca3e94b@finder"
                },
                "live_info": {
                  "wechat_uin": "3586779100",
                  "live_id": "2078666200539415802",
                  "live_status": 1,
                  "online_count": 1,
                  "start_time": 1711516592,
                  "like_count": 0,
                  "reward_total_amount_in_wecoin": "1",
                  "nickname": "unknown",
                  "head_url": ""
                },
                "events": [
                  {
                    "msg_time": 1711517211196,
                    "msg_sub_type": 20013,
                    "msg_id": "finderlive_appmsg_finderlive_comborewardmsg_2a3d0649774dcbf6066486c473d773a4_2078666200539415802_MMFinderLiveGift100001_eb2a00ab883c67826230c3026cd09b31_733209994431_268_8b8ec23d8c82bf3f45509e33e994a7a2",
                    "sec_openid": "v2_060000231003b20faec8cae3881fc7d5ce06e837b077c370cf6ab3f650e1d27bd9a155b7e252@finder",
                    "nickname": "每日读.物",
                    "seq": "10",
                    "decoded_type": "combogift",
                    "sec_gift_id": "MMFinderLiveGift100001",
                    "combo_product_count": 1,
                    "content": "每日读.物送了主播1个爱心",
                    "decoded_openid": "o9hHn5QFOR8mdiDj9W-XFXJZLLKs"
                  }
                ]
              }' http://192.168.10.104:8081/"forward"
        """
    }
}



