//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class DopViewController: UIViewController {
    
    let textLabel1 = UILabel()

    var aboutText:NSAttributedString = NSMutableAttributedString(string:"")
    var politikaText:NSAttributedString = NSMutableAttributedString(string:"");
    override func viewDidLoad() {
            // screen width and height:
        view.addBackground(image: "bgMenu")
        
        setupUI()
        super.viewDidLoad()
        
    }
    
    func setupUI(){
        let navigations = view.addNavigation(i:2)
        
        
        navigations[0].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        navigations[1].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        navigations[2].addTarget(self, action: #selector(self.click), for:.touchUpInside)
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        self.textLabel1.frame = CGRect(x: 24, y: 128+32+10, width: view.bounds.maxX-48, height: view.bounds.maxY - 120 - 128+32+10);
        let items = ["О проекте", "Политика"]
        let segmentBtn = UISegmentedControl(items: items)

        let textLabel2 = UILabel()
        textLabel1.textColor = UIColor(red: 0.495, green: 0.564, blue: 0.801, alpha: 1)
        textLabel1.text = "\n"
        textLabel1.numberOfLines = 0
        textLabel1.textAlignment = .left
        
        textLabel1.sizeToFit();
        textLabel1.lineBreakMode = .byWordWrapping
        
        segmentBtn.selectedSegmentIndex = 0
        segmentBtn.frame = CGRect(x: 24, y: 128, width: view.bounds.maxX-48, height: 32)
        
        view.addSubview(segmentBtn)
        view.addSubview(textLabel1)
        view.addSubview(textLabel2)
        segmentBtn.layer.cornerRadius = 5.0  // Don't let background bleed
        segmentBtn.backgroundColor = UIColor(red: 0.271, green: 0.318, blue: 0.447, alpha: 1)
        
        segmentBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "SFProText-Medium", size: 12)!,NSAttributedString.Key.foregroundColor: UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)], for: .normal)
        segmentBtn.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "SFProText-Medium", size: 12)!,NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        segmentBtn.selectedSegmentTintColor = UIColor(red: 0.36, green: 0.42, blue: 0.6, alpha: 1)
        segmentBtn.addTarget(self, action: #selector(self.clickSegment), for:.valueChanged)
        let label = UILabel(frame: CGRect(x: 24, y: 66, width: view.bounds.maxX-48, height: 36))
        label.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Bold", size: 32)
        view.addSubview(label)
        paragraphStyle.lineHeightMultiple = 0.94
        
        // Line height: 36 pt
        // (identical to box height)
        label.attributedText = NSMutableAttributedString(string: "Еще", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        clickSegment(seg:segmentBtn)
    }
    
    @objc func exit(){
        let def = UserDefaults.standard
        def.set("",forKey: "token");
        self.performSegue(withIdentifier: "goLoader", sender: nil)
    }
    
    @objc func editProfile(){
        self.performSegue(withIdentifier: "goEditProfile", sender: nil)
    }
 
    
    @objc func clickSegment(seg:UISegmentedControl) {
        var text:NSAttributedString  = NSMutableAttributedString(string:"");

        if(seg.selectedSegmentIndex==1){
            if(self.politikaText.length==0){
                Api().get(url:"page/politika") { result in
                    switch result {
                        case .success(let res):
                        
                        DispatchQueue.main.async {
                            self.politikaText = self.htmlAttributedString2(res: res["description"] as! String)!
                            self.textLabel1.attributedText = self.politikaText
                            //res//(res.htmlToAttributedString)
                            self.textLabel1.numberOfLines = 0
                            self.textLabel1.sizeToFit();
                            self.textLabel1.lineBreakMode = .byWordWrapping
                            self.textLabel1.textColor = UIColor(red: 0.495, green: 0.564, blue: 0.801, alpha: 1)
                            
                        }
                        case .failure(let error):
                        switch error {
                            case .notAuthenticated:
                            self.textLabel1.attributedText = "Произошла ошибка проверте электронную почтку".htmlToAttributedString
                            case .custom(let message):
                            self.textLabel1.attributedText = message.htmlToAttributedString
                        }
                        
                    }
                    
                }
            } else {
                text = self.politikaText
            }
        } else {
            if(self.aboutText.length==0){
                Api().get(url:"page/about") { result in
                    switch result {
                        case .success(let res):
                        
                        DispatchQueue.main.async {
                            self.aboutText = self.htmlAttributedString2(res: res["description"] as! String)!
                            self.textLabel1.attributedText = self.aboutText
                            //res//(res.htmlToAttributedString)
                            self.textLabel1.numberOfLines = 0
                            self.textLabel1.sizeToFit();
                            self.textLabel1.lineBreakMode = .byWordWrapping
                            self.textLabel1.textColor = UIColor(red: 0.495, green: 0.564, blue: 0.801, alpha: 1)
                            
                        }
                        case .failure(let error):
                        switch error {
                            case .notAuthenticated:
                            self.textLabel1.attributedText = "Произошла ошибка проверте электронную почтку".htmlToAttributedString
                            case .custom(let message):
                            self.textLabel1.attributedText = message.htmlToAttributedString
                        }
                        
                    }
                    
                }
            } else {
                text = self.aboutText
            }
        }
        if(text.length>0){
            self.textLabel1.attributedText = text
            //res//(res.htmlToAttributedString)
            self.textLabel1.numberOfLines = 0
            self.textLabel1.sizeToFit();
            self.textLabel1.lineBreakMode = .byWordWrapping
            self.textLabel1.textColor = UIColor(red: 0.495, green: 0.564, blue: 0.801, alpha: 1)
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
    
    func htmlAttributedString2(res: String) -> NSAttributedString? {
        
        guard let data = res.data(using: .utf8) else {
            return nil
        }

        guard let attributedString = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
            ) else {
            return nil
        }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil);

    }
    
    
    
}
