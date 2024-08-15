//
//  Constant.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/11.
//

import OSLog
import UIKit

typealias ValueAction = (_ T: Any) -> Void

func mylog(_ items: Any..., toast: Bool = true) {
    print("WxLiveGiftPlayer ❄️❄️❄️❄️", #function, items)
    if toast {
        // 使用自定义toast
        DispatchQueue.main.async {
            ToastView.shared.showToast(message: items.first as? String ?? "")
        }        
    }
}

extension Notification.Name {
    static let playPagEffects = NSNotification.Name("playPagEffects")
    static let startRtmp = NSNotification.Name("startRtmp")
    static let stopRtmp = NSNotification.Name("stopRtmp")
}

class ToastView: UIView {
    static let shared = ToastView()
    private var messageLabel: UILabel!

    private init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true

        messageLabel = UILabel()
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        self.addSubview(messageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showToast(message: String, duration: TimeInterval = 3.0) {
        messageLabel.text = message

        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.frame = CGRect(x: 16, y: window.bounds.height - window.safeAreaInsets.bottom - 40, width: window.bounds.width-32, height: 40)
        messageLabel.frame = self.bounds

        window.addSubview(self)
        self.alpha = 1.0

        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
