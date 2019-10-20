//
//  UIViewControllerExtension.swift
//  LoginFunction(firebase)
//
//  Created by 강민석 on 2019/10/20.
//  Copyright © 2019 강민석. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title: String?, message: String, handler: ((UIAlertAction) -> Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:  handler))
        self.present(alert, animated: true, completion: nil)
    }
}
