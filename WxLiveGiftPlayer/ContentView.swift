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
            
            VStack {
                Spacer()
                
                Text("礼物体验馆")
                    .font(.largeTitle)
                    .foregroundColor(.pink)
                    .stroke(color: .white, width: 1)
                
                Text("赠小礼物看大特效")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.pink)
                    .stroke(color: .white, width: 0.5)
                
                DigitalClockView()
                
                if !giftListHidden {
                    ScrollView {
                        GeometryReader(content: { geometry in
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
                                    .onTapGesture {
                                        if model.smallTitle.contains("环球旅行") {
                                            currentPath = randomModel.pagPath
                                            randomModel = ListModel.randomModel
                                        } else {
                                            currentPath = model.pagPath
                                        }
                                        pathDidChange.toggle()
                                        giftListHidden.toggle()
                                    }
                                }
                            })
//                            .border(.green, width: 5)
                            .padding(EdgeInsets(top: 40, leading: 16, bottom: 40, trailing: 16))
                            .frame(maxWidth: geometry.size.width)
                            .frame(maxHeight: geometry.size.width + 30)
                        })
                    }
//                    .border(.red, width: 5)
                    .scrollIndicators(.hidden)
                    .frame(maxWidth: screenWidth, maxHeight: screenHeight*2/3)
                }
                
                Spacer()
            }
            
            if pathDidChange {
                PlayPagView(pagPath: $currentPath.wrappedValue, pagStop: { _ in
                    print("停止播放")
                    pathDidChange.toggle()
                    giftListHidden.toggle()
                })
                .padding()
//                .border(.red, width: 5)
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
        NotificationCenter.default.addObserver(forName: .playPagEffects, object: nil, queue: nil) { notify in
            
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

//#Preview {
//    ContentView()
//}
