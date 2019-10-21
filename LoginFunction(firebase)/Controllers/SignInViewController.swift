//
//  SignUpViewController.swift
//  LoginFunction(firebase)
//
//  Created by 강민석 on 2019/10/21.
//  Copyright © 2019 강민석. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var signUpEmailField: UITextField!
    @IBOutlet weak var signUpPwField: UITextField!

    @IBAction func signUpButton(_ sender: Any) {
        guard let email = signUpEmailField.text, let password = signUpPwField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else { return }

            if error == nil {
                self.dismiss(animated: true)
            } else {
                self.alert(title: "Warning", message: "error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
