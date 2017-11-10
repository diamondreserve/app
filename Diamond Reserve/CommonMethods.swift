//
//  CommonMethods.swift
//  Recmend
//
//  Created by PSIHPOK on 7/4/17.
//  Copyright © 2017 PSIHPOK. All rights reserved.
//

import Foundation
import UIKit

class CommonMethods {
    
    class func showAlert(withTitle titleStr: String, message msgStr: String, andCancelButtonTitle btnStr: String?, with controller: UIViewController?) {
            var vc = controller as UIViewController?
            // use UIAlertController for iOS8
            let alert = UIAlertController(title: titleStr, message: msgStr, preferredStyle: .alert)
            let cancel = UIAlertAction(title: btnStr, style: .default, handler: {(_ action: UIAlertAction) -> Void in
                alert.dismiss(animated: false, completion: { _ in })
            })
            alert.addAction(cancel)
            if vc == nil {
                vc = self.controllerForPresentingAlert()
            }
            vc!.present(alert, animated: true, completion: { _ in })
    }
    
    class func controllerForPresentingAlert()-> UIViewController{
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        var lastController: UIViewController?
        while ((topController?.presentedViewController) != nil) {
            if (topController?.presentedViewController is UIAlertController) {
                return lastController!
            }
            lastController = topController?.presentedViewController
            topController = topController?.presentedViewController
        }
        return topController!
    }
    
}
