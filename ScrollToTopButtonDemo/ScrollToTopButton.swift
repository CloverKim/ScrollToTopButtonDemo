//
//  ScrollToTopButton.swift
//  UDPhone
//
//  Created by 江顺金 on 2017/6/2.
//  Copyright © 2017年 115.com. All rights reserved.
//

import UIKit

// 这是扩展的方案
//extension UIScrollView {
//    
//    func addScrollToTopBtn() -> ScrollToTopButton {
//        return ScrollToTopButton(frame: CGRect(x: (self.width - 40) / 2, y: self.height + 100, width: 40, height: 40), scrollView: self)
//    }
//}


class ScrollToTopButton: UIView {

    weak var scrollView: UIScrollView?
    var scrollToTopBtn = UIButton(type: .custom)
    private var isShow = false
    
    init(frame: CGRect, scrollView: UIScrollView) {
        super.init(frame: frame)
        guard let superView = scrollView.superview else { return }
        self.center.x = superView.center.x
        scrollToTopBtn.frame = superView.bounds
        scrollToTopBtn.setImage(#imageLiteral(resourceName: "go_top"), for: .normal)
        scrollToTopBtn.addTarget(self, action: #selector(scrollToTopAction), for: .touchUpInside)
        addSubview(scrollToTopBtn)
        self.scrollView = scrollView
        superView.addSubview(self)
        self.center.y = superView.frame.size.height - 40
        self.isHidden = true
        self.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin]
        observe(scrollView, keyPath: #keyPath(UIScrollView.contentOffset)) { [weak self] (weakSelf, oldValue, newValue) in
            if scrollView.contentOffset.y <= 0 {
                self?.hiddenScrollToTopBtn()
            } else {
                if (scrollView.isDragging || scrollView.isDecelerating) && !scrollView.isTracking && scrollView.contentOffset.y > superView.frame.size.height {
                    self?.isShow = true
                    self?.isHidden = false
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.center.y = superView.frame.size.height - 40
                    })
                } else if self?.isShow == true {
                    self?.cancelHide()
                    self?.perform(#selector(ScrollToTopButton.hiddenScrollToTopBtn), with: nil, afterDelay: 3)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollToTopBtn.frame = bounds
        if let centerX = scrollView?.center.x {
            self.center.x = centerX
        }
    }
    
    /// 取消延迟执行
    private func cancelHide() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(ScrollToTopButton.hiddenScrollToTopBtn), object: nil)
    }
    
    /// 隐藏滚到顶部按钮方法
    @objc private func hiddenScrollToTopBtn() {
        if let scrollView = scrollView, let superView = scrollView.superview {
            UIView.animate(withDuration: 0.5, animations: {
                self.center.y = superView.frame.size.height + 40
            }, completion: { (true) in
                self.isHidden = true
            })
        }
    }
    
    /// 滚到顶部按钮的点击事件
    @objc private func scrollToTopAction() {
        if let scrollView = scrollView {
            UIView.animate(withDuration: 0.5, animations: {
                scrollView.scrollRectToVisible(CGRect(x:0, y:0, width:1, height:1), animated: true)
            })
            // 隐藏按钮
            hiddenScrollToTopBtn()
        }
    }
    
}
