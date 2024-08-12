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
                    .resizable()
//                    .ignoresSafeArea()
                    .padding(.zero)
//                    .aspectRatio(contentMode: .fit)
            }
//            .padding()
            
            Rectangle()
                .colorMultiply(Color.black.opacity(0.5)) // 应用半透明黑色效果
            
            Text("礼物体验馆")
                .font(.largeTitle)
                .foregroundColor(.pink)
                .stroke(color: .white, width: 1)
                .padding(EdgeInsets(top: -320.ratioHeight, leading: 0, bottom: 0, trailing: 0))
            
            Text("赠小礼物看高级特效, `环球旅行`为随机特效")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.pink)
                .stroke(color: .white, width: 0.5)
                .padding(EdgeInsets(top: -270.ratioHeight, leading: 0, bottom: 0, trailing: 0))
            
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
                            .padding(EdgeInsets(top: 0, leading: 10.ratioWidth, bottom: 0, trailing: 10.ratioWidth))
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
                    .padding(EdgeInsets(top: 50.ratioHeight, leading: 0, bottom: 0, trailing: 0))
                }
//                .border(.red, width: 5)
                .scrollIndicators(.hidden)
//                .frame(width: 230.ratioWidth)
                .padding(EdgeInsets(top: 180.ratioHeight, leading: 0.ratioWidth, bottom: 150.ratioHeight, trailing: 0.ratioWidth))
            }
            
            if pathDidChange {
                PlayPagView(pagPath: $currentPath.wrappedValue, pagStop: { _ in
                    print("停止播放")
                    pathDidChange.toggle()
                    giftListHidden.toggle()
                })
//                    .padding()
//                .aspectRatio(contentMode: .fit)
//                .ignoresSafeArea()
                    .onTapGesture {
                        pathDidChange.toggle()
                        giftListHidden.toggle()
                    }
            }
        }
        .ignoresSafeArea()
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
