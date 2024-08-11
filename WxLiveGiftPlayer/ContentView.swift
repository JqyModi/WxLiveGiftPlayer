//
//  ContentView.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/6.
//

import SwiftUI
import libpag

struct ContentView: View {
    
    var models = ListModel.listData()
    
    @State var currentPath: String = ListModel.listData().randomElement()?.pagPath ?? ""
    
    @State var randomModel: ListModel = ListModel.randomModel
    
    @State var pathDidChange = false
    @State var giftListHidden = false
    
    var body: some View {
        ZStack {
            VStack {
                Image("live_bg")
                    .imageScale(.large)
            }
            .padding()
            
            Rectangle()
                .colorMultiply(Color.black.opacity(0.5)) // 应用半透明黑色效果
            
            Text("礼物体验馆")
                .font(.largeTitle)
                .foregroundColor(.pink)
                .stroke(color: .white, width: 1)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: UIScreen.main.bounds.height/2 + 200, trailing: 0))
            
            Text("赠小礼物看高级特效, `环球旅行`为随机特效")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.pink)
                .stroke(color: .white, width: 0.5)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: UIScreen.main.bounds.height/2 + 120, trailing: 0))
            
            if !giftListHidden {
                ScrollView {
                    LazyVStack(alignment: .leading, content: {
                        ForEach(models, id: \.self) { item in
                            let model = item.smallTitle.contains("环球旅行") ? randomModel : item
                            HStack(alignment: .center, spacing: 4) {
                                Image(model.smallImg)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text(model.smallTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text(" > ")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                Image(model.bigImg)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text(model.bigTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                            .disabled(false)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .onTapGesture {
                                if model.smallTitle.contains("环球旅行") {
                                    currentPath = randomModel.pagPath
                                    randomModel = ListModel.randomModel
                                } else {
                                    currentPath = model.pagPath
                                }
                                
//                                currentPath = model.pagPath
                                pathDidChange.toggle()
                                giftListHidden.toggle()
                            }
                        }
                    })
                    .padding(EdgeInsets(top: 150, leading: 0, bottom: 0, trailing: 0))
                }
                .scrollIndicators(.hidden)
                .frame(width: 230)
    //            .background(Color(white: 0.0, opacity: 0.3))
    //            .mask({
    //                LinearGradient(gradient: Gradient(colors: [Color.black, Color.black.opacity(0.99) , Color.black.opacity(0.88), Color.black.opacity(0.4)]), startPoint: .leading, endPoint: .trailing)
    //            })
                .padding(EdgeInsets(top: 100, leading: 12, bottom: 100, trailing: 170))
            }
            
            if pathDidChange {
                PlayPagView(pagPath: $currentPath.wrappedValue, pagStop: { _ in
                    print("停止播放")
                    pathDidChange.toggle()
                    giftListHidden.toggle()
                })
                    .padding()
//                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
//                    .disabled(true)
                    .onTapGesture {
                        pathDidChange.toggle()
                        giftListHidden.toggle()
                    }
            }
        }
        .onAppear {
            handleLiveComment()
        }
    }
}

extension ContentView {
    func handleLiveComment() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("playPagEffects"), object: nil, queue: nil) { notify in
            
            guard 
                let userInfo = notify.userInfo,
                let giftName = userInfo["giftName"] as? String
            else { return }
            
            print("giftName: ", giftName)
            
            pathDidChange = false
            giftListHidden = false
            
            if giftName.contains("环球旅行") {
                currentPath = randomModel.pagPath
                randomModel = ListModel.randomModel
            } else {
                let pagPath = models.first(where: { $0.smallTitle.contains(giftName) })?.pagPath
                currentPath = pagPath ?? ""
            }
            
            pathDidChange = true
            giftListHidden = true
        }
    }
}

#Preview {
    ContentView()
}
