//
//  PlayPagVC.swift
//  WxLiveGiftPlayer
//
//  Created by J.qy on 2024/8/7.
//

import UIKit
import libpag
import SnapKit
import SwiftUI

class PlayPagVC: UIViewController {
    
    // PAG显示视图
    lazy var pagView: PAGView = {
        let view = PAGView()
        view.add(self)
        return view
    }()

    // PAG资源文件
    var pagFile: PAGFile?
    
    var pagStop: ValueAction?

    // 素材文件路径
    var resourcePath: String? {
        didSet {
            configData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        configPagView()
        configData()
    }
    
    func configPagView() {
        view.addSubview(pagView)
        pagView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configData() {
        pagView.stop()
        
        guard let path = resourcePath else {
            return
        }
        
//        pagFile = PAGFile.load(path)
//        pagView.setComposition(pagFile)
        pagView.setPath(path)
        
        pagView.setRepeatCount(2)
        
        pagView.play()
        
        view.sendSubviewToBack(pagView)
    }
}

extension PlayPagVC: PAGViewListener {
    func onAnimationEnd(_ pagView: PAGView!) {
        print("特效播放结束")
        pagStop?(true)
    }
}

struct PlayPagView: UIViewRepresentable {
    
    var pagPath: String?
    
    var pagStop: ValueAction?
    
    let vc = PlayPagVC()
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        print(#function)
        vc.resourcePath = pagPath
    }
    
    func makeUIView(context: Context) -> some UIView {
        vc.resourcePath = pagPath
        vc.pagStop = { _ in
            self.pagStop?(true)
        }
        return vc.view
    }
}
