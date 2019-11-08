//
//  PWViewController.swift
//  LoginFunction(firebase)
//
//  Created by 강민석 on 2019/11/04.
//  Copyright © 2019 강민석. All rights reserved.
//

import UIKit
import Firebase

class PWViewController: UIViewController {
    
    var bottomMargin: CGFloat?
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var placeholderLabel: UILabel!
    
    @IBOutlet weak var PWField: UITextField!
    
    @IBAction func movePrevious(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    var emailText: String!
    
    var tokens = [NSObjectProtocol]()
    
    deinit {
        tokens.forEach{ NotificationCenter.default.removeObserver($0) }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        PWField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.alpha = 0.0
        titleLabelBottomConstraint.constant = -20
        
        bottomConstraint.constant = bottomMargin ?? 0.0
        UIView.performWithoutAnimation {
            self.view.layoutIfNeeded()
        }

        var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            if let frameValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardFrame = frameValue.cgRectValue
                self?.bottomConstraint.constant = self?.bottomMargin ?? keyboardFrame.size.height
                
                UIView.animate(withDuration: 0.3, animations: {
                    self?.view.layoutIfNeeded()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: UITextFieldDelegate implement
extension PWViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        placeholderLabel.alpha = (textField.text ?? "").count > 0 ? 0.0 : 1.0
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalText = NSMutableString(string: textField.text ?? "")
        finalText.replaceCharacters(in: range, with: string)
        
        placeholderLabel.alpha = finalText.length > 0 ? 0.0 : 1.0
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.titleLabel.alpha = finalText.length > 0 ? 1.0 : 0.0
            self?.titleLabelBottomConstraint.constant = finalText.length > 0 ? 0 : -20
            
            self?.view.layoutIfNeeded()
        }
        
        return true
    }
}

//MARK: firebase login
extension PWViewController {
        @IBAction func loginButton(_ sender: Any) {
            Auth.auth().signIn(withEmail: emailText+"@gmail.com", password: PWField.text!) { (user, error) in
                if user != nil{
                    self.alert(title: "로그인 성공!", message: "메인화면으로 이동 구현 필요")
//                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let nextView = storyboard.instantiateInitialViewController()
//                    self.present(nextView!, animated: true, completion: nil)
                    // TODO: 로그인 성공 user 객체에서 정보 사용
                } else {
                    self.alert(title: "로그인 실패", message: "이메일이나 비밀번호를 확인해주세요")
                    // TODO: 로그인 실패 처리
                }
            }
        }
}
