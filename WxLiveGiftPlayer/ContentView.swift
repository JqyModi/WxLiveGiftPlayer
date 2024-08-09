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
            
            if !giftListHidden {
                ScrollView {
                    LazyVStack(alignment: .leading, content: {
                        ForEach(models, id: \.self) { model in
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
                                currentPath = model.pagPath
                                pathDidChange.toggle()
                                giftListHidden.toggle()
                            }
                        }
                    })
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
                PlayPagView(pagPath: $currentPath.wrappedValue)
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
            NotificationCenter.default.addObserver(forName: NSNotification.Name("playPagEffects"), object: nil, queue: nil) { notify in
                pathDidChange = false
                giftListHidden = false
                currentPath = ListModel.listData().randomElement()?.pagPath ?? ""
                pathDidChange = true
                giftListHidden = true
            }
        }
    }
}

#Preview {
    ContentView()
}
