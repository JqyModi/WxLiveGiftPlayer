//
//  RtmpConfigView.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/14.
//

import SwiftUI

struct RtmpConfigView: View {
    @State private var rtmpUrl: String = LiveRtmpPush.shared.rtmpURL
    @State private var streamKey: String = LiveRtmpPush.shared.rtmpSecret
    
    @State private var rtmpOpen: Bool = LiveRtmpPush.shared.rtmpOpen

    var vc: UIViewController?
    
    var body: some View {
        VStack(content: {
            Button(action: {
                vc?.dismiss(animated: true)
            }) {
                Text("返回")
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .fontWeight(.semibold)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .foregroundColor(.red)
                    .cornerRadius(16)
            }
            
            CardView {
                VStack(spacing: 20) {
                    TextField("请输入RTMP推流地址", text: $rtmpUrl)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    TextField("请输入密钥", text: $streamKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
            }
            .padding()
            
            HStack(content: {
                Button(action: startRtmp) {
                    Text("开启")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: !rtmpOpen ? .systemPink : .lightGray))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .disabled(!rtmpOpen)
                }
                
                Button(action: stopRtmp) {
                    Text("关闭")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: rtmpOpen ? .systemPink : .lightGray))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .disabled(rtmpOpen)
                }
            })
            .padding()
        })
    }

    private func save() {
        // 这里可以添加点击确认按钮后的处理逻辑
        mylog("RTMP URL: \(rtmpUrl), Stream Key: \(streamKey)")
        LiveRtmpPush.shared.rtmpURL = rtmpUrl
        LiveRtmpPush.shared.rtmpSecret = streamKey
//        LiveRtmpPush.shared.rtmpOpen = rtmpOpen
    }

    private func startRtmp() {
        save()
        rtmpOpen = true
        NotificationCenter.default.post(name: .startRtmp, object: nil)
    }

    private func stopRtmp() {
        save()
        rtmpOpen = false
        NotificationCenter.default.post(name: .stopRtmp, object: nil)
    }
}

struct CardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5)
        }
    }
}

struct RtmpConfigView_Previews: PreviewProvider {
    static var previews: some View {
        RtmpConfigView()
    }
}

