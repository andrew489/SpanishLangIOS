//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    let field1: TextField = TextField();
    let field2: TextField = TextField();
    let field3: TextField = TextField();
    
    let imagePicker = UIImagePickerController();
    
    let imageView = UIImageView();
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
            // screen width and height:
        view.addBackground(image: "bg")
        
        setupUI()
        super.viewDidLoad()
        downloadImage(from:  URL(string:defaults.string(forKey: "avatar")  ?? "https://myprojectdomen.ru/storage/images/def_avatar.png")!)
    }
    
    func setupUI(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        
        let label = UILabel(frame: CGRect(x: view.bounds.midX-40, y: 59, width: 80, height: 18))
        self.view.addSubview(label)
    
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProText-Regular", size: 18)
        paragraphStyle.lineHeightMultiple = 0.84
        // Line height: 18 pt
        // (identical to box height)
        label.textAlignment = .center
        label.attributedText = NSMutableAttributedString(string: "Профиль", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        
        let done = UIButton(frame: CGRect(x: view.bounds.maxX-86-24, y: 52, width: 86, height: 32))
        self.view.addSubview(done)
        done.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        done.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 16)
        done.layer.cornerRadius = 8
        done.layer.backgroundColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        paragraphStyle.lineHeightMultiple = 0.84
        // Line height: 16 pt
        // (identical to box height)
        done.titleLabel?.textAlignment = .center
        done.setTitle("Готово", for: .normal)
        
        field1.frame = CGRect(x: 24, y: 238, width: view.bounds.maxX-48, height: 56);
        field2.frame = CGRect(x: 24, y: 238+56+12, width: view.bounds.maxX-48, height: 56);
        field3.frame = CGRect(x: 24, y: (238+56+12)+56+12, width: view.bounds.maxX-48, height: 56);
       
        self.view.addSubview(field1)
        self.view.addSubview(field2)
        self.view.addSubview(field3)
        field1.text = defaults.string(forKey: "name")
        field2.text = defaults.string(forKey: "email")
        done.addTarget(self, action: #selector(self.done), for:.touchUpInside)
        
       
        field1.placeholder = "Email";
        field1.attributedPlaceholder =
        NSAttributedString(string: "Вашe имя", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
        field2.placeholder = "Email";
        field2.attributedPlaceholder =
        NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
        field2.isEnabled = false
        field3.placeholder = "Ваш пароль";
        field3.attributedPlaceholder =
        NSAttributedString(string: "Ваш пароль", attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)])
        
        field1.setLabel();
        field2.setLabel();
        field3.setLabel();
        
        let changeAvatarBtn = UIButton(frame: CGRect(x: view.bounds.midX-85.5, y: 190, width: 171, height: 32))
        self.view.addSubview(changeAvatarBtn)
        
        changeAvatarBtn.layer.backgroundColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        changeAvatarBtn.layer.cornerRadius = 16
        changeAvatarBtn.setTitle("Изменить аватар", for: .normal)
        changeAvatarBtn.setTitleColor(.white, for: .normal)
        changeAvatarBtn.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 16)
        changeAvatarBtn.addTarget(self, action: #selector(self.changeAvatar), for:.touchUpInside)
        
        imageView.frame =  CGRect(origin: CGPoint(x: view.bounds.midX-32, y: 109), size: CGSize(width: 64, height: 64))
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        imageView.layer.cornerRadius = 32
    
        
        view.addSubview(imageView)
        
        
    
        
    }
    
    @objc func done(){
    
        let def = UserDefaults.standard
        def.set(field1.text,forKey: "name");
//        def.set(field2.text,forKey: "email");
        
        self.performSegue(withIdentifier: "goProfile", sender: nil)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            
            DispatchQueue.main.async() { [weak self] in
                let img = UIImage(data: data)
                self?.imageView.image = img
                self?.imageView.layer.cornerRadius = 32
                self?.imageView.layer.masksToBounds = true
            }
        }
    }
    
    @objc func changeAvatar() {
        ImagePickerManager().pickImage(self){ image in
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = image
//                print(image.accessibilityPath?.cgPath)
                Api().uploadFile(file: image, fileName: "avatar.png", fileExtension: "file")
            }
        }

        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
            print("imagePickerController")
            self.dismiss(animated: true, completion: { () -> Void in
            })
            imageView.image = image
    }
    
    
    
}
