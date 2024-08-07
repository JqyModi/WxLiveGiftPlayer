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
            
//            List {
//                LazyVStack(alignment: .leading, content: {
//                    ForEach(models, id: \.self) { model in
//                        HStack(alignment: .center, spacing: 4) {
//                            Image(model.smallImg)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                            Text(model.smallTitle + " > ")
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                            Image(model.bigImg)
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                            Text(model.bigTitle)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                        .background(.red)
//                        .contentShape(Rectangle())
//                        .onTapGesture {
//                            currentPath = model.pagPath
//                        }
//                    }
//                })
//                .frame(width: 200)
//                .background(Color(white: 0.0, opacity: 0.2))
//                .padding(EdgeInsets(top: 100, leading: 50, bottom: 150, trailing: 230))
//            }
            
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
            
//            PlayPagView(pagPath: currentPath)
//                .padding()
//                .disabled(true)
        }
    }
}

//#Preview {
//    ContentView()
//}

import SwiftUI

struct Item: Identifiable {
    let id = UUID()
    let title: String
}

struct ItemListView: View {
    let items: [Item] = [
        Item(title: "Item 1"),
        Item(title: "Item 2"),
        Item(title: "Item 3")
    ]
    
    var body: some View {
//        List(items) { item in
//            Text(item.title)
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    // 当item被点击时，执行的代码
//                    self.itemTapped(item: item)
//                }
//        }
        
        ForEach(items) {
            Text($0.title)
        }
        .background(.red)
    }
    
    func itemTapped(item: Item) {
        // 这里处理点击事件，例如弹出一个警告框
        print("Item tapped: \(item.title)")
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
