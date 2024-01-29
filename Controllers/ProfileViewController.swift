//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
   
    let imageView = UIImageView();
    
    
    override func viewDidLoad() {
            // screen width and height:
        view.addBackground(image: "bgMenu")
        
        setupUI()
        super.viewDidLoad()
        
    }

    func setupUI(){
        
        let navigations = view.addNavigation(i:1)

        
        navigations[0].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        navigations[1].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        navigations[2].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        

        
        let paragraphStyle = NSMutableParagraphStyle()
        
        let aboutBtn = UIButton(frame: CGRect(origin: CGPoint(x: 24, y: 182), size: CGSize(width: view.bounds.maxX-48, height: 56)))
        aboutBtn.layer.backgroundColor = UIColor(red: 0.965, green: 0.749, blue: 0, alpha: 1).cgColor
        aboutBtn.layer.cornerRadius = 28
        view.addSubview(aboutBtn)
        aboutBtn.titleLabel?.textColor = UIColor(red: 0.035, green: 0.039, blue: 0.039, alpha: 1)
        
        aboutBtn.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
        
        
        paragraphStyle.lineHeightMultiple = 0.84
        // Line height: 16 pt
        // (identical to box height)
        aboutBtn.titleLabel?.textAlignment = .center
        aboutBtn.titleLabel?.attributedText = NSMutableAttributedString(string: "О проекте", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        aboutBtn.setTitleColor(UIColor(red: 0.035, green: 0.039, blue: 0.039, alpha: 1), for: .normal)
        aboutBtn.setTitle("О проекте", for:.normal)
        aboutBtn.addTarget(self, action: #selector(self.about), for:.touchUpInside)
        let policyBtn = UIButton(frame: CGRect(origin: CGPoint(x: 24, y: 250), size: CGSize(width: view.bounds.maxX-48, height: 56)))
        policyBtn.layer.backgroundColor = UIColor(red: 0.965, green: 0.749, blue: 0, alpha: 1).cgColor
        policyBtn.layer.cornerRadius = 28
        view.addSubview(policyBtn)
        policyBtn.titleLabel?.textColor = UIColor(red: 0.035, green: 0.039, blue: 0.039, alpha: 1)
        policyBtn.setTitleColor(UIColor(red: 0.035, green: 0.039, blue: 0.039, alpha: 1), for: .normal)
        

        policyBtn.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
        
        
        paragraphStyle.lineHeightMultiple = 0.84
        // Line height: 16 pt
        // (identical to box height)
        policyBtn.titleLabel?.textAlignment = .center
        policyBtn.titleLabel?.attributedText = NSMutableAttributedString(string: "Политика конфиденциальности", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        policyBtn.setTitle("Политика конфиденциальности", for:.normal)
        policyBtn.addTarget(self, action: #selector(self.policy), for:.touchUpInside)
        
        let stroke = UIView()
        
        stroke.bounds = view.bounds.insetBy(dx: -0.5, dy: -0.5)
        stroke.center = view.center
        stroke.frame = CGRect(x: 24, y: 166, width: view.bounds.maxX-48, height: 1)
        view.addSubview(stroke)
        stroke.layer.borderWidth = 1
        stroke.layer.borderColor = UIColor(red: 0.271, green: 0.318, blue: 0.447, alpha: 1).cgColor
        
        let defaults = UserDefaults.standard
        
        let nameL = UILabel(frame: CGRect(origin: CGPoint(x: 104, y: 65), size: CGSize(width: view.bounds.maxX-80-104, height: 32)))
        nameL.text = defaults.string(forKey: "name")
        let emailL = UILabel(frame: CGRect(origin: CGPoint(x: 104, y: 97), size: CGSize(width: view.bounds.maxX-80-104, height: 32)))
        view.addSubview(emailL)
        view.addSubview(nameL)
        emailL.text = defaults.string(forKey: "email")
        emailL.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        nameL.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        nameL.font = UIFont(name: "SFProDisplay-Bold", size: 24)
        
        paragraphStyle.lineHeightMultiple = 1.12
    
        // Line height: 32 pt
        // (identical to box height)
        nameL.attributedText = NSMutableAttributedString(string: defaults.string(forKey: "name") ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])

        
        paragraphStyle.lineHeightMultiple = 1.05
        emailL.font = UIFont(name: "SFProText-Regular", size: 16)
        emailL.attributedText = NSMutableAttributedString(string: defaults.string(forKey: "email") ?? "", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        let EditProfileBtn = UIButton(frame: CGRect(origin: CGPoint(x: view.bounds.maxX-24-56, y: 65), size: CGSize(width: 56, height: 56)));
        view.addSubview(EditProfileBtn)
        EditProfileBtn.setImage(UIImage(named: "profileBtn"), for: .normal)
        EditProfileBtn.addTarget(self, action: #selector(self.editProfile), for:.touchUpInside)
        
        imageView.frame =  CGRect(origin: CGPoint(x: 24, y: 61), size: CGSize(width: 64, height: 64))
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        imageView.layer.cornerRadius = 32
    
        
        view.addSubview(imageView)
        if((defaults.string(forKey: "avatar")) != nil){
            downloadImage(from:  URL(string:defaults.string(forKey: "avatar")!)!)
        }
    }
    
    @objc func exit(){
        let def = UserDefaults.standard
        def.set("",forKey: "token");
        self.performSegue(withIdentifier: "goLoader", sender: nil)
    }
    @objc func about(){
//        let def = UserDefaults.standard
//        def.set("",forKey: "token");
        self.performSegue(withIdentifier: "goDop", sender: nil)
    }
    @objc func policy(){
//        let def = UserDefaults.standard
//        def.set("",forKey: "token");
        self.performSegue(withIdentifier: "goDop", sender: nil)
    }
    @objc func editProfile(){
        self.performSegue(withIdentifier: "goEditProfile", sender: nil)
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
                self?.imageView.layer.masksToBounds = true
                self?.imageView.layer.cornerRadius = 32
            }
        }
    }
    
    @objc func click(btn:UIButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil)
        let trenagerController = vc.instantiateViewController(withIdentifier: "trainer") as! TrainerViewController
        let profile = vc.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        let dopController = vc.instantiateViewController(withIdentifier: "about") as! DopViewController
        
//        self.present(dopController, animated: true, completion: nil)
        self.present((btn.tag==1 ? trenagerController : (btn.tag==2 ? profile : (btn.tag==3  ? dopController : dopController))), animated: true)
    }
}
