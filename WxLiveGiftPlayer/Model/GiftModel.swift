//
//  GiftModel.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/7.
//

import Foundation

struct ListModel: Hashable, Identifiable {
    let id = UUID()
    
    var smallTitle: String
    var bigTitle: String
    var smallImg: String
    var bigImg: String
    var pag: String
    
    var pagPath: String {
        return Bundle.main.path(forResource: pag, ofType: nil) ?? ""
    }
}

extension ListModel {
    
    static var randomModel: ListModel {
        let pags = pagInfo()
        var model = ListModel(smallTitle: "环球旅行", bigTitle: "", smallImg: "环球旅行.thumb", bigImg: "", pag: "")
        let random = pags[0..<pags.count].randomElement()
        model.bigTitle = random?.replacingOccurrences(of: ".pag", with: "") ?? "为你加冕"
        model.bigImg = random?.replacingOccurrences(of: ".pag", with: ".thumb") ?? "为你加冕"
        model.pag = random ?? "为你加冕.pag"
        return model
    }
    
    static func listData() -> [ListModel] {
        var result = [ListModel]()
        
        let smalls = smallGiftInfo()
        let bigs = bigGiftInfo()
        let pags = pagInfo()
        for i in 0..<smalls.count {
            let bigTitle = bigs[i].replacingOccurrences(of: ".thumb", with: "")
            let model = ListModel(smallTitle: smalls[i].replacingOccurrences(of: ".thumb", with: ""), bigTitle: bigTitle, smallImg: smalls[i], bigImg: bigs[i], pag: pags.first(where: { $0.contains(bigTitle) }) ?? "为你加冕.pag")
            result.append(model)
        }
        
        return result
    }
    
    static func smallGiftInfo() -> [String] {
        return [
            "粉丝牌.thumb",
            "爱心.thumb",
            "棒棒糖.thumb",
            "干杯.thumb",
            "咖啡.thumb",
            "草莓蛋糕.thumb",
            "撸串.thumb",
            "晚安.thumb",
            "奶茶.thumb",
            "口红.thumb",
            "抱抱.thumb",
            "环球旅行.thumb",
        ]
    }
    
//    static func smallGiftInfo() -> [String] {
//        return [
//            "party.thumb",
//            "打CALL.thumb",
//            "能量饮料.thumb",
//            "守护-紫.thumb",
//            "守护-红.thumb",
//            "守护-水晶.thumb",
//            "加油.thumb",
//            "口红.thumb",
//            "咖啡.thumb",
//            "啤酒.thumb",
//            "奶茶.thumb",
//            "情书.thumb",
//            "抱抱.thumb",
//            "撸串.thumb",
//            "晚安.thumb",
//            "比心.thumb",
//            "毛笔.thumb",
//            "灯牌.thumb",
//            "炸弹.thumb",
//            "玫瑰.thumb",
//            "眼镜.thumb",
//            "蛋糕.thumb",
//            "锦鲤.thumb",
//            "雪球.thumb",
//            "飞吻.thumb",
//            "真好听.thumb",
//            "真好看.thumb",
//            "不分离.thumb",
//            "么么哒.thumb",
//            "人气宝.thumb",
//            "加油鸭.thumb",
//            "小心心.thumb",
//            "小飞机.thumb",
//            "巧克力.thumb",
//            "幸运星.thumb",
//            "我来了.thumb",
//            "棒棒糖.thumb",
//            "摸摸头.thumb",
//        ]
//    }
    
    static func bigGiftInfo() -> [String] {
        return [
            
//            "人气传送.thumb",
//            "璨石之冠.thumb",
//            "臻爱花束.thumb",
//            "萌星守护.thumb",
//            "谍影星光.thumb",
//            "采兰赠芍.thumb",
//            "心动泡泡机.thumb",
            
//            "水瓶座.thumb",
//            "狮子座.thumb",
//            "白羊座.thumb",
//            "金牛座.thumb",
//            "巨蟹座.thumb",
//            "双子座.thumb",
//            "双鱼座.thumb",
//            "火箭-红.thumb",
//            "火箭-绿.thumb",
//            "火箭-蓝.thumb",
//            "火箭-金.thumb",
//            "火箭-黄.thumb",
//            "火箭-红-条纹.thumb",
//            "超级跑车-白-888.thumb",
//            "超级跑车-红-888.thumb",
//            "超级跑车-蓝-888.thumb",
//            "超级跑车-黄-888.thumb",
//            "超级跑车-黑-888.thumb",
//            "超级跑车-白.thumb",
//            "超级跑车-红.thumb",
//            "超级跑车-蓝.thumb",
//            "超级跑车-黄.thumb",
            "告白气球.thumb",
            "万柿兴龙.thumb",
            "火箭-粉.thumb",
            "超级跑车-黑.thumb",
            "摘星星.thumb",
            "游乐园.thumb",
            "一生一世.thumb",
            "一见钟情.thumb",
            "为你加冕.thumb",
            "桃花岛.thumb",
            "仙境之翼.thumb",
            "天使守护.thumb",
            "心动座驾.thumb",
            "情意合钗.thumb",
            "星际飞船.thumb",
            "梦幻城堡.thumb",
            "浪漫之夜.thumb",
            "海景别墅.thumb",
            "海洋之心.thumb",
            "环球旅行.thumb",
            "甜蜜告白.thumb",
            "画龙点睛.thumb",
            "真爱召唤.thumb",
            "私人飞机.thumb",
            "繁华都市.thumb",
            "豪华游艇.thumb",
            "长相厮守.thumb",
            "环宇空间站.thumb",
        ]
    }
    
    static func pagInfo() -> [String] {
        return [
            "party.pag",
            "star.pag",
            "打CALL.pag",
            "火箭-红-条纹.pag",
            "守护-粉.pag",
            "守护-紫.pag",
            "火箭-粉.pag",
            "火箭-红.pag",
            "火箭-绿.pag",
            "火箭-蓝.pag",
            "火箭-黄.pag",
            "守护-水晶.pag",
            "火箭-金色.pag",
            "口红.pag",
            "奶茶.pag",
            "情书.pag",
            "抱抱.pag",
            "晚安.pag",
            "比心.pag",
            "锦鲤.pag",
            "不分梨.pag",
            "人气宝.pag",
            "加油鸭.pag",
            "双子座.pag",
            "双鱼座.pag",
            "小飞机.pag",
            "巧克力.pag",
            "巨蟹座.pag",
            "幸运星.pag",
            "我来了.pag",
            "摘星星.pag",
            "桃花岛.pag",
            "水瓶座.pag",
            "游乐园.pag",
            "狮子座.pag",
            "白羊座.pag",
            "金牛座.pag",
            "超级跑车-红-888.pag",
            "超级跑车-蓝-888.pag",
            "超级跑车-黄-888.pag",
            "超级跑车-黑-888.pag",
            "环球旅行-粉.pag",
            "环球旅行-蓝.pag",
            "环球旅行-金.pag",
            "超级跑车-白.pag",
            "超级跑车-红.pag",
            "超级跑车-黄.pag",
            "环球旅行-斜塔.pag",
            "环球旅行-星际.pag",
            "环球旅行-长城.pag",
            "环球旅行-金字塔.pag",
            "一生一世.pag",
            "一见钟情.pag",
            "万柿兴龙.pag",
            "为你加冕.pag",
            "人气传送.pag",
            "仙境之翼.pag",
            "告白气球.pag",
            "天使守护.pag",
            "心动座驾.pag",
            "情意合钗.pag",
            "星际飞船.pag",
            "梦幻城堡.pag",
            "浪漫之夜.pag",
            "海景别墅.pag",
            "海洋之心.pag",
            "甜蜜告白.pag",
            "画龙点睛.pag",
            "真爱召唤.pag",
            "私人飞机.pag",
            "繁华都市.pag",
            "萌星守护.pag",
            "蝶影星光.pag",
            "豪华游艇.pag",
            "采兰赠芍.pag",
            "长相厮守.pag",
            "雪球覆盖.pag",
            "心动泡泡机.pag",
            "环宇空间站.pag",
        ]
    }
}




