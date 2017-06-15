

import UIKit

typealias KVONotificationBlock = (Any?, _ oldValue: Any?, _ value: Any?) -> Void

extension NSObject {
    //默认的函数，option的初始值是Initial|New, 监测打变化的值默认转到主线程
    func observe(_ object: Any?, keyPath: String, block: @escaping KVONotificationBlock) {
        self.kvoController.observe(object, keyPath: keyPath, options:[.initial, .new], block:{(observer: Any?, object: Any, change: [String: Any]) in
            DispatchQueue.main.async(execute: { () -> Void in
                block(observer, change["old"], change["new"]);
            })
        })
    }
    
    func observe(_ object: Any?, keyPath: String, options: NSKeyValueObservingOptions, mainThread: Bool, block: @escaping KVONotificationBlock) {
        self.kvoController.observe(object, keyPath: keyPath, options: options) { (observer, object, change: [String: Any]) -> Void in
            if !mainThread || Thread.isMainThread == true  {
                block(observer, change["old"], change["new"]);
            } else {
                DispatchQueue.main.async(execute: { () -> Void in
                    block(observer, change["old"], change["new"]);
                })
            }
        }
    }
    
    func removeObserve(_ object: Any?, path: String) {
        self.kvoController.unobserve(object, keyPath: path);
    }
    
    func removeObserve(_ obj: Any?) {
        self.kvoController.unobserve(obj);
    }
    
    func removeAll() {
        self.kvoController.unobserveAll();
    }
}
