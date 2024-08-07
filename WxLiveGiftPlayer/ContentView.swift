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
    
    var body: some View {
        ZStack {
            VStack {
                Image("live_bg")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            }
            .padding()
            
            List {
                LazyVStack(alignment: .leading, content: {
                    ForEach(models, id: \.self) { model in
                        HStack(alignment: .center, spacing: 4) {
                            Image(model.smallImg)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(model.smallTitle + " > ")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Image(model.bigImg)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(model.bigTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .disabled(false)
                        .background(.red)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            print("点击", model.pagPath)
                            currentPath = model.pagPath
                        }
                    }
                })
                .frame(width: 200)
                .background(Color(white: 0.0, opacity: 0.2))
                .padding(EdgeInsets(top: 100, leading: 50, bottom: 150, trailing: 230))
            }
            
//            List(models) {
//                let model = $0
//                HStack(alignment: .center, spacing: 4) {
//                    Button {
//                        print("点击时间", model.pagPath)
//                        currentPath = model.pagPath
//                    } label: {
//                        Image(model.smallImg)
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                        Text(model.smallTitle + " > ")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                        Image(model.bigImg)
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                        Text(model.bigTitle)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                    }
//                }
//                .background(.red)
//            }
//            .background(.yellow)
            
            PlayPagView(pagPath: $currentPath.wrappedValue)
                .padding()
                .disabled(true)
        }
    }
}

#Preview {
    ContentView()
}
