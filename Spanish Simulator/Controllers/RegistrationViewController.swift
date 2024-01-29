//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    
   
    let field1: TextField = TextField();
    
    let field2: TextField = TextField();
    let field3: TextField = TextField();
    let errorLabel = UILabel();
    let labelFogot = UIButton()
    let button = RedButton()
    let leftBtn = LeftButton()
    var isKeyboard = false
    
    
    override func viewDidLoad() {
            // screen width and height:
        view.addBackground(image: "bg")

        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI(){
        
        self.view.addSubview(field1)
        self.view.addSubview(field2)
        self.view.addSubview(field3)
        self.view.addSubview(leftBtn)

        field1.attributedPlaceholder =
        NSAttributedString(string: "Ваше имя", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
    
        field2.attributedPlaceholder =
        NSAttributedString(string: "Ваш e-mail", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
        
        field3.attributedPlaceholder =
        NSAttributedString(string: "Ваш пароль", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
        
        field1.setLabel()
        
        field2.setLabel()
        field3.setLabel()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.84
        let label = UILabel(frame: CGRect(x: 24, y: 59, width: view.bounds.maxX-48, height: 18))
        self.view.addSubview(label)

        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 18)

        label.attributedText = NSMutableAttributedString(string: "Регистрация", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
       
        label.textAlignment = .center
        
        
        self.view.addSubview(labelFogot)
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        button.frame =  CGRect(x: 24, y: view.bounds.maxY-80, width: view.bounds.maxX-48, height: 56)
        
        self.view.addSubview(button)
        self.view.addSubview(errorLabel)
        
        

       
        labelFogot.titleLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 12)
        labelFogot.setTitleColor(UIColor(red: 0.953, green: 0.635, blue: 0.024, alpha: 1), for: .normal)
        labelFogot.contentHorizontalAlignment = .left
        
        let stringValue = "Продолжая работу вы соглашаетесь с политикой конфиденциальности и условиями использования"
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
        attributedString.setColor(color: .white, forText: "Продолжая работу вы соглашаетесь")

        labelFogot.setAttributedTitle(attributedString, for: .normal)

        field1.frame = CGRect(x: 24, y: 108, width: view.bounds.maxX-48, height: 56)
        field2.frame = CGRect(x: 24, y: 108+56+12, width: view.bounds.maxX-48, height: 56)
        field3.frame = CGRect(x: 24, y: 108+56+12+56+12, width: view.bounds.maxX-48, height: 56)
        
        
        labelFogot.frame = CGRect(origin: CGPoint(x: 40, y: view.bounds.maxY-132), size: CGSize(width: view.bounds.maxX-80, height: 32))
        
        labelFogot.titleLabel?.lineBreakMode = .byWordWrapping
        labelFogot.titleLabel?.numberOfLines = 0
        labelFogot.titleLabel?.textAlignment = .left
        

       
        paragraphStyle.lineHeightMultiple = 0.84


        button.setAttributedTitle(NSMutableAttributedString(string: "Регистрация", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
        
        errorLabel.textColor = UIColor(red: 0.882, green: 0.016, blue: 0.012, alpha: 1)
        errorLabel.font = UIFont(name: "SFProText-Regular", size: 14)
        
        paragraphStyle.lineHeightMultiple = 0.96
        // Line height: 16 pt
        // (identical to box height)
        errorLabel.attributedText = NSMutableAttributedString(string: "Вы ввели неверный пароль", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        errorLabel.frame = CGRect(origin: CGPoint(x: 40, y: 108+56+12+56+12+56+4), size: CGSize(width: view.bounds.midX-64, height: 20))
        errorLabel.contentMode = .scaleAspectFill
        
        
        labelFogot.addTarget(self, action: #selector(self.registration), for:.touchUpInside)
        
        button.addTarget(self, action: #selector(self.registration), for:.touchUpInside)
        leftBtn.addTarget(self, action: #selector(self.leftAction), for:.touchUpInside)
    }
    
    @objc func registration(){
        let defaults = UserDefaults.standard
        Api().post(url:"auth/register",parameters: ["name":field1.text ?? "","email":field2.text ?? "","password":field3.text ?? ""]) { result in
            print(result)
            switch result {
                case .success(let res):
                guard let message = try? res["message"] else {
                    
                    DispatchQueue.main.async {
                        defaults.set(res["token"] as Any as! String,forKey: "token")
                        self.performSegue(withIdentifier: "goLoader", sender: nil)
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.field3.layer.borderColor = UIColor(red: 0.675, green: 0.082, blue: 0.114, alpha: 1).cgColor
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = message as? String
                
               }
                
            
                case .failure(let error):
                switch error {
                case .notAuthenticated:
                    self.field3.layer.borderColor = UIColor(red: 0.675, green: 0.082, blue: 0.114, alpha: 1).cgColor
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = "Произошла ошибка проверте логин и пароль!"
                case .custom(let message):
                    print(message)
                    self.field3.layer.borderColor = UIColor(red: 0.675, green: 0.082, blue: 0.114, alpha: 1).cgColor
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
            
            button.frame =  CGRect(x: 24, y: view.bounds.maxY - keyboardHeight - 50 - 24, width: view.bounds.maxX-48, height: 56)
            labelFogot.frame = CGRect(origin: CGPoint(x: 40, y: view.bounds.maxY  - keyboardHeight - 132), size: CGSize(width: view.bounds.maxX-80, height: 32))
           }
       
    }

    @objc func keyboardWillDisappear() {
        button.frame =  CGRect(x: 24, y: view.bounds.maxY-80, width: view.bounds.maxX-48, height: 56)
        labelFogot.frame = CGRect(origin: CGPoint(x: 40, y: view.bounds.maxY-132), size: CGSize(width: view.bounds.maxX-80, height: 32))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func leftAction() {
        dismiss(animated: true, completion: nil)
    }
    
}
