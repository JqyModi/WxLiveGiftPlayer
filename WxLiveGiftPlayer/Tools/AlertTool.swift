//
//  AlertTool.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/11.
//

import UIKit

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
