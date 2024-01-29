//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class ForgotEmailController: UIViewController {
    
   
    
    let field1: TextField = TextField();
    let field2: TextField = TextField();
    
    let errorLabel = UILabel();
    var labelDesc = UILabel();
    var mainLabel = UILabel();

    let button = RedButton()
    let leftBtn = LeftButton()
    var isKeyboard = false
    var email = "";
    var code = "";
    let labelFogotY = 55 + 18 + 31 + 58 + 12 + 58 + 8
    
    override func viewDidLoad() {
            // screen width and height:
        view.addBackground(image: "bg")

        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        
        self.view.addSubview(field1)
        field2.isHidden = true
        self.view.addSubview(field2)

        self.view.addSubview(leftBtn)

        field1.attributedPlaceholder =
        NSAttributedString(string: "Ваш e-mail", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
    
    
        field1.setLabel()
        
        field2.attributedPlaceholder =
        NSAttributedString(string: "Ваш e-mail", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
    
    
        field2.setLabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.84
        mainLabel = UILabel(frame: CGRect(x: 24, y: 120, width: view.bounds.maxX-48, height: 36))
        self.view.addSubview(mainLabel)

        mainLabel.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        mainLabel.font = UIFont(name: "SFProDisplay-Bold", size: 32)

        mainLabel.attributedText = NSMutableAttributedString(string: "Забыли пароль?", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
       
        mainLabel.textAlignment = .left
        
        labelDesc = UILabel(frame: CGRect(x: 24, y: 164, width: view.bounds.maxX-48, height: 40))
        self.view.addSubview(labelDesc)

        labelDesc.textColor = UIColor(red: 0.592, green: 0.612, blue: 0.62, alpha: 1)
        labelDesc.font = UIFont(name: "SFProText-Regular", size: 16)
        labelDesc.numberOfLines = 0
        labelDesc.lineBreakMode = .byWordWrapping
    
        paragraphStyle.lineHeightMultiple = 1.05
        // Line height: 20 pt
        labelDesc.attributedText = NSMutableAttributedString(string: "Введите адрес эл. почты, чтобы получить код для изменения пароля", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        
        
    
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        button.frame =  CGRect(x: 24, y: view.bounds.maxY-80, width: view.bounds.maxX-48, height: 56)
        
        self.view.addSubview(button)
        self.view.addSubview(errorLabel)
        
        button.setTitleColor(UIColor(red: 0.035, green: 0.039, blue: 0.039, alpha: 1), for: .normal)
        button.backgroundColor = .white
        button.setBackgroundImage(nil, for: .normal)
        
        field1.frame = CGRect(x: 24, y: 222, width: view.bounds.maxX-48, height: 56)
       
        paragraphStyle.lineHeightMultiple = 0.84


        button.setAttributedTitle(NSMutableAttributedString(string: "Получить код", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
        
        errorLabel.textColor = UIColor(red: 0.882, green: 0.016, blue: 0.012, alpha: 1)
        errorLabel.font = UIFont(name: "SFProText-Regular", size: 14)
        
        paragraphStyle.lineHeightMultiple = 0.96
        // Line height: 16 pt
        // (identical to box height)
        errorLabel.attributedText = NSMutableAttributedString(string: "Вы ввели неверный пароль", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        errorLabel.frame = CGRect(origin: CGPoint(x: 40, y: 222+56+5), size: CGSize(width: view.bounds.midX-64, height: 20))
        errorLabel.contentMode = .scaleAspectFill
        
         
        button.addTarget(self, action: #selector(self.sendCode), for:.touchUpInside)
        leftBtn.addTarget(self, action: #selector(self.leftAction), for:.touchUpInside)
    }
    
    @objc func sendCode() {
        Api().post(url:"auth/forgot-password",parameters: ["email":field1.text ?? ""]) { result in
            switch result {
                case .success(let res):
                    guard let status = try? res["status"] else {
                        DispatchQueue.main.async {
                            self.errorLabel.text = res["message"] as? String;
                            self.errorLabel.isHidden = false
                        }
                        return
                    }
                    if((res["status"] != nil) == true){
                        DispatchQueue.main.async {
                            self.email = self.field1.text ?? "";
                            self.errorLabel.isHidden = true
                            let paragraphStyle = NSMutableParagraphStyle()
                            paragraphStyle.lineHeightMultiple = 0.84
                            self.mainLabel.attributedText = NSMutableAttributedString(string: "Ввод кода", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                            
                            paragraphStyle.lineHeightMultiple = 0.96
                            self.labelDesc.attributedText = NSMutableAttributedString(string: "Введите полученый код который пришел на email, чтобы изменить пароль", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

                            self.field1.changeLabel(str: "Код")
                            self.field1.text=""
                            self.field1.placeholderLabel?.text=""
                            self.field1.setLabel()
                            self.button.setAttributedTitle(NSMutableAttributedString(string: "Проверить код", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
                            self.button.removeTarget(nil, action: nil, for: .allEvents)
                            self.button.addTarget(self, action: #selector(self.changePassword), for:.touchUpInside)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.errorLabel.text = res["message"] as? String;
                            self.errorLabel.isHidden = false
                        }
                    }
                        
                
            
                case .failure(let error):
                switch error {
                    case .notAuthenticated:
                    
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Произошла ошибка проверте электронную почтку"
                    case .custom(let message):
                    
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = message
                }
                
            }
            
        }
                
    }
    
    @objc func changePassword() {
        Api().post(url:"auth/check_code",parameters: ["email":email,"code":field1.text ?? ""]) { result in
            switch result {
                case .success(let res):
                print(res)
                guard let status = try? res["status"] else {
                    DispatchQueue.main.async {
                        self.errorLabel.text = res["message"] as? String;
                        self.errorLabel.isHidden = false
                    }
                    return
                }
                if((res["status"] != nil) == true){
                    DispatchQueue.main.async {
                        self.errorLabel.isHidden = true
                        self.code = self.field1.text ?? "";
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineHeightMultiple = 0.84
                        self.mainLabel.attributedText = NSMutableAttributedString(string: "Обновите пароль", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
                        
                        self.labelDesc.isHidden = true
                        
                        self.field1.changeLabel(str: "Введите новый пароль")
                        self.field2.changeLabel(str: "Повторите новый пароль")
                        self.field1.text=""
                        self.field1.placeholderLabel?.text=""
                        self.field1.setLabel()
                        self.field2.text = ""
                        self.field1.frame = CGRect(x: 24, y: 168, width: self.view.bounds.maxX-48, height: 56)
                        self.field2.frame = CGRect(x: 24, y: 240, width: self.view.bounds.maxX-48, height: 56)
                        self.field2.isHidden = false
                        self.button.setAttributedTitle(NSMutableAttributedString(string: "Обновить пароль", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
                        self.button.removeTarget(nil, action: nil, for: .allEvents)
                        self.button.addTarget(self, action: #selector(self.updatePassword), for:.touchUpInside)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorLabel.text = res["message"] as? String;
                        self.errorLabel.isHidden = false
                    }
                }
            
                
            
                case .failure(let error):
                switch error {
                    case .notAuthenticated:
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Произошла ошибка проверте электронную почтку"
                    case .custom(let message):
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = message
                }
                
            }
            
        }
        
        
        
    }
    
    @objc func updatePassword() {
        Api().post(url:"auth/change_password",parameters: ["email":email,"password":field1.text ?? "","code":code]) { result in
            switch result {
                case .success(let res):
                
                guard let status = try? res["status"] else {
                    DispatchQueue.main.async {
                        self.errorLabel.isHidden = true
                        self.errorLabel.text = res["message"] as? String;
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            
                
            
                case .failure(let error):
                switch error {
                    case .notAuthenticated:
                    
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = "Произошла ошибка проверте электронную почтку"
                    case .custom(let message):
                    
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = message
                }
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillAppear(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardRectangle = keyboardFrame.cgRectValue
               let keyboardHeight = keyboardRectangle.height
            self.errorLabel.isHidden = true
            button.frame =  CGRect(x: 24, y: view.bounds.maxY - keyboardHeight - 50 - 24, width: view.bounds.maxX-48, height: 56)
           }
       
    }

    @objc func keyboardWillDisappear() {
        self.errorLabel.isHidden = true
        button.frame =  CGRect(x: 24, y: view.bounds.maxY-80, width: view.bounds.maxX-48, height: 56)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func leftAction() {
        dismiss(animated: true, completion: nil)
    }
}
