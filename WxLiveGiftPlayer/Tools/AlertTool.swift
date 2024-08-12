//
//  AlertTool.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/11.
//

import UIKit
import SwiftUI

let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height

class AlertUtil {
    static func showAlert(title: String, message: String, actions: [UIAlertAction] = []) {
        // 获取当前活动的场景
//        guard let windowScene = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first(where: { $0.activationState == .foregroundActive }) else {
//            print("无法找到活动的场景")
//            return
//        }
//        
//        // 获取当前场景的顶层控制器
//        guard let topController = windowScene.windows.first?.rootViewController?.topMostViewController() else {
//            print("无法找到顶层控制器")
//            return
//        }
        guard let topController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController() else {
            print("无法找到顶层控制器")
            return
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 添加自定义的action
        for action in actions {
            alertController.addAction(action)
        }
        
        // 添加默认的取消按钮
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 在主线程中展示alert
        DispatchQueue.main.async {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
}

extension UIViewController {
    // 辅助函数，用于找到顶层控制器
    func topMostViewController() -> UIViewController {
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        } else if let nav = self as? UINavigationController {
            return nav.visibleViewController?.topMostViewController() ?? self
        } else if let tab = self as? UITabBarController, let selected = tab.selectedViewController {
            return selected.topMostViewController()
        } else {
            return self
        }
    }
}


// MARK: SwiftUI扩展
extension View {
    func stroke(color: Color, width: CGFloat = 1) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    private func appliedStrokeBackground(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask(alignment: .center) {
                        mask(content: content)
                    }
            )
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

extension CGFloat {
    var ratioWidth: CGFloat {
        return self * screenWidth / 375
    }
    
    var ratioHeight: CGFloat {
        return self * screenHeight / 812
    }
}

extension Int {
    var ratioWidth: CGFloat {
        return CGFloat(self) * screenWidth/375
    }
    
    var ratioHeight: CGFloat {
        return CGFloat(self) * screenHeight/812
    }
}
