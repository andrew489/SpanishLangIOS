//
//  ViewController.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class LoaderViewController: UIViewController {
    
    struct loginAuthResponce:Codable {
        var token:String
        
        var success:Bool
    }
    // Спиннер - размер 100
        private lazy var spinner: CustomSpinnerSimple = {
            let spinner = CustomSpinnerSimple(squareLength: 100)
            return spinner
        }()

        
    
    override func viewDidLoad() {
            // screen width and height:
        view.addBackground(image: "bgLoad")
        super.viewDidLoad()
        view.addSubview(spinner)
        spinner.startAnimation(delay: 0.04, replicates: 12)
        let button = RedButton()
        let button2 = RedButton()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.84
        button.frame =  CGRect(x: 24, y: view.bounds.maxY-170, width: view.bounds.maxX-48, height: 56)
        button.setAttributedTitle(NSMutableAttributedString(string: "Регистрация", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
        
        button2.frame =  CGRect(x: 24, y: view.bounds.maxY-98, width: view.bounds.maxX-48, height: 56)
        button2.setAttributedTitle(NSMutableAttributedString(string: "У меня уже есть аккаунт", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
        button2.setTitleColor(UIColor(red: 0.035, green: 0.039, blue: 0.039, alpha: 1), for: .normal)
        button2.backgroundColor = .white
        button2.setBackgroundImage(nil, for: .normal)
        self.view.addSubview(button)
        self.view.addSubview(button2)
        button.isHidden = true
        button2.isHidden = true
        
        button.addTarget(self, action: #selector(self.goReg), for: .touchUpInside)
        button2.addTarget(self, action: #selector(self.goLogin), for: .touchUpInside)
        spinner.isHidden = false

        Api().get(url:"user") { result in
            switch result {
                case .success(let res):
                DispatchQueue.main.async {

                    let defaults = UserDefaults.standard
                    defaults.set(res["avatar_url"] as Any as! String,forKey: "avatar")
                    defaults.set(res["email"] as Any as! String,forKey: "email")
                    defaults.set(res["name"] as Any as! String,forKey: "name")
                    self.performSegue(withIdentifier: "goProfile", sender: nil)
               }
                case .failure(let error):
                    switch(error){
                       
                        case .notAuthenticated:
                            DispatchQueue.main.async {
                                self.spinner.isHidden = true
                                button.isHidden = false
                                button2.isHidden = false
                                
                           }
                        default: 
                        DispatchQueue.main.async {
                            self.spinner.isHidden = true
                            button.isHidden = false
                            button2.isHidden = false
                       }
                    }
            }
            
        }
    }
    
    @objc func goReg(){
        self.performSegue(withIdentifier: "goReg", sender: nil)
    }
    @objc func goLogin(){
        self.performSegue(withIdentifier: "goLogin", sender: nil)
    }
}
extension UIView {

    func addBackground(image:String)  {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height

        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: image)!

            // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill

        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
        
//        return imageViewBackground
    }
    func addNavigation(i:Int) -> [UIButton]{
        let btn1 = UIButton();
        let btn2 = UIButton();
        let btn3 = UIButton();
        
        let height = CGFloat(92)
        let bottom = UIScreen.main.bounds.size.height - 21 - height
        let width = ((UIScreen.main.bounds.size.width - 48 - 16)/3)

        
        var configuration = UIButton.Configuration.plain()
        configuration.baseBackgroundColor =  nil
        
        btn1.frame = CGRectMake(24, bottom, width, height)
        btn2.frame = CGRectMake(24+btn1.bounds.width, bottom, width, height)
        btn3 .frame = CGRectMake(24+btn1.bounds.width+8+btn2.bounds.width+8, bottom, width, height)
        
        btn1.setTitle("Тренажер", for: .normal)
        btn2.setTitle("Профиль", for: .normal)
        btn3.setTitle("Еще", for: .normal)
        
        self.addSubview(btn1)
        self.addSubview(btn2)
        self.addSubview(btn3)
        
        btn1.titleLabel?.textColor = .white
        btn2.titleLabel?.textColor = .white
        btn3.titleLabel?.textColor = .white
        
        
        btn1.setBackgroundImage(UIImage(named: "navBg"), for: .selected)
        btn2.setBackgroundImage(UIImage(named: "navBg"), for: .selected)
        btn3.setBackgroundImage(UIImage(named: "navBg"), for: .selected)
        
//        btn1.isSelected = true
        
        
        btn1.contentMode = .scaleAspectFit
        btn2.contentMode = .scaleAspectFit
        btn3.contentMode = .scaleAspectFit
        
        btn1.setImage(UIImage(named: "trainerIcon"), for: .normal)
        btn2.setImage(UIImage(named: "personIcon"), for: .normal)
        btn3.setImage(UIImage(named: "moreIcon"), for: .normal)
        
        btn1.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 10)
        btn2.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 10)
        btn3.titleLabel?.font = UIFont(name: "SFProText-Regular", size: 10)
        
        btn1.titleLabel?.textAlignment = .center
        btn2.titleLabel?.textAlignment = .center
        btn3.titleLabel?.textAlignment = .center
        
        btn1.tag = 1
        btn2.tag = 2
        btn3.tag = 3
        
        btn1.contentHorizontalAlignment = .center
        btn2.contentHorizontalAlignment = .center
        btn3.contentHorizontalAlignment = .center
        
        btn1.imageView?.contentMode = .scaleAspectFit
        btn2.imageView?.contentMode = .scaleAspectFit
        btn3.imageView?.contentMode = .scaleAspectFit
        
        btn1.contentMode = .scaleAspectFit
        btn2.contentMode = .scaleAspectFit
        btn3.contentMode = .scaleAspectFit
               
        btn1.imageEdgeInsets = UIEdgeInsets(top: -40,left: (btn1.bounds.width/2)-15,bottom: 0,right: 0)
        btn2.imageEdgeInsets = UIEdgeInsets(top: -40,left: (btn2.bounds.width/2)-25,bottom: 0,right: 0)
        btn3.imageEdgeInsets = UIEdgeInsets(top: -40,left: (btn3.bounds.width/2)-50,bottom: 0,right: 0)
        
        btn1.titleEdgeInsets = UIEdgeInsets(top: 0,left: -12,bottom: 0,right: 0)
        btn2.titleEdgeInsets = UIEdgeInsets(top: 0,left: -15,bottom: 0,right: 0)
        btn3.titleEdgeInsets = UIEdgeInsets(top: 0,left: -20,bottom: 0,right: 0)
    
        btn1.imageView?.layer.transform = CATransform3DMakeScale(3, 3, 3)
        btn2.imageView?.layer.transform = CATransform3DMakeScale(3, 3, 3)
        btn3.imageView?.layer.transform = CATransform3DMakeScale(3, 3, 3)
        
        btn1.backgroundColor = .clear
        btn2.backgroundColor = .clear
        btn3.backgroundColor = .clear
        
        
        let navigation = [btn1,btn2,btn3];
        navigation.forEach {
            $0.isSelected = false
            $0.isEnabled = true
        }
        navigation[i].isEnabled = true
        navigation[i].isSelected = true
        return navigation
    }
    
    @objc func click(btn:UIButton) {
    }
    
}
// An attributed string extension to achieve colors on text.
extension NSMutableAttributedString {

    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

}
extension UIButton {
    @objc func setText(text:String){
        
    }
    
    @objc func setTag(id:Int){
        
    }
     
    @objc func getHeight() -> Int{
        return 94
    }
    
    @objc func setIndex(index:Int){
    
    }
    @objc func setData(data:[String:Any]){
    
    }
    
    @objc func setPosition(frame:[String:Int]){
        self.frame = CGRect(x: frame["x"]!, y:  frame["y"]!, width: frame["width"]!, height: frame["height"]!)
    }
    
    @objc func setLinkImage(link:String){
        
    }
    
    @objc func getData() -> [String:Any]{
        return [:]
    }
    @objc func hasSelect() -> Bool {
        return false
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

