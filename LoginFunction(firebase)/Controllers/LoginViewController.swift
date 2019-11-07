//
//  LoginViewController.swift
//  LoginFunction(firebase)
//
//  Created by 강민석 on 2019/10/21.
//  Copyright © 2019 강민석. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var placeholderLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    /**
     emailField 문자입력 제약 추가
     */
    let charSet: CharacterSet = {
        var cs = CharacterSet.capitalizedLetters
        cs.insert(charactersIn: "@")
        cs.insert(charactersIn: " ")
        return cs // 허용되지 않는 문자 반환
    }()
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    var tokens = [NSObjectProtocol]()
    
    deinit {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tokens.forEach{ NotificationCenter.default.removeObserver($0) }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailField.becomeFirstResponder()
        
        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            if let frameValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                self?.bottomConstraint.constant = keyboardFrame.size.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
                }, completion: { finished in
                    UIView.setAnimationsEnabled(true)
                })
            }
        }
        tokens.append(token)
        
        token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.bottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, animations: {
                self?.view.layoutIfNeeded()
            })
        }
        tokens.append(token)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PWViewController {
            vc.bottomMargin = bottomConstraint.constant
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.isEnabled = false
        
    }
    
    var presented = false
    
//    @IBAction func loginButton(_ sender: Any) {
//        Auth.auth().signIn(withEmail: emailField.text!, password: pWField.text!) { (user, error) in
//            if user != nil{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let nextView = storyboard.instantiateInitialViewController()
//                self.present(nextView!, animated: true, completion: nil)
//                // TODO: 로그인 성공 user 객체에서 정보 사용
//            } else {
//                self.alert(title: "로그인 실패", message: "이메일이나 비밀번호를 확인해주세요")
//                // TODO: 로그인 실패 처리
//            }
//        }
//    }
    
}

//MARK: 델리게이트 패턴 구현
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let cnt = textField.text?.count ?? 0
        
        if cnt > 0 {
            performSegue(withIdentifier: "PWSegue", sender: nil)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !presented {
            UIView.setAnimationsEnabled(false)
            presented = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 입력 값 검사
        if string.count > 0 {
            guard string.rangeOfCharacter(from: charSet) == nil else {
                return false
            }
        }
        
        let finalText = NSMutableString(string: textField.text ?? "")
        finalText.replaceCharacters(in: range, with: string)
        
        let font = textField.font ?? UIFont.systemFont(ofSize: 16)
        
        let dict = [NSAttributedString.Key.font: font]
        
        let width = finalText.size(withAttributes: dict).width
        
        placeholderLeadingConstraint.constant = width
        
        if finalText.length == 0 {
            placeholderLabel.text = "Example@gmail.com"
        } else {
            placeholderLabel.text = "@gmail.com"
        }
        
        nextButton.isEnabled = finalText.length > 0
        
        return true
    }
    
}




// 파이어 베이스 참고 : http://monibu1548.github.io/2019/01/13/firebase-auth-1/
