//
//  LoginViewController.swift
//  LoginFunction(firebase)
//
//  Created by 강민석 on 2019/10/21.
//  Copyright © 2019 강민석. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pWField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: pWField.text!) { (user, error) in
            if user != nil{
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let nextView = storyboard.instantiateInitialViewController()
                self.present(nextView!, animated: true, completion: nil)
                // TODO: 로그인 성공 user 객체에서 정보 사용
            } else {
                self.alert(title: "Noob", message: "Check Email or PW")
                // TODO: 로그인 실패 처리
            }
        }
    }
    
}
