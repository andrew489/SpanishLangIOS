//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class AnswerButton: UIButton {

    
    var data:[String:Any] = [:]
    var isSelect:Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.22).cgColor
        layer.cornerRadius = 25
        
        setTitleColor(UIColor(red: 0.91, green: 0.941, blue: 0.914, alpha: 1), for: .normal)
        
        titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.99
        // Line height: 20 pt
        // (identical to box height)
        titleLabel?.textAlignment = .center
//        setAttributedTitle(NSMutableAttributedString(string: "Далее", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
        

    }
    
    func success(){
        setBackgroundImage(UIImage(named: "successAnswer"), for: .normal)
        setBackgroundImage(UIImage(named: "successAnswer"), for: .disabled)
        layer.borderColor = UIColor(red: 0.192, green: 0.627, blue: 0.498, alpha: 1).cgColor
        
    }
    override func setPosition(frame:[String:Int]){
        self.frame = CGRect(x: 24, y:  frame["y"]!, width: frame["width"]!, height: 50)
    }
    override func setData(data:[String:Any]){
        self.data = data
    }
    override func setTag(id:Int){
        tag = id
    }
    
    override func setText(text:String){
        setTitle(text, for: .normal)
    }
    func setSelected(){
        self.isSelect = true
        self.layer.borderColor = UIColor(red: 0.495, green: 0.564, blue: 0.801, alpha: 1).cgColor
    }
    
    func bad(){
        self.setBackgroundImage(UIImage(named: "redBtn"), for: .normal)
        self.setBackgroundImage(UIImage(named: "redBtn"), for: .disabled)
        self.layer.borderColor = UIColor(red: 0.882, green: 0.016, blue: 0.012, alpha: 0.1).cgColor
    }
    
    override func getHeight() -> Int{
        return 50+12
    }
    override func hasSelect() -> Bool{
        return self.isSelect
    }
    override func getData() -> [String:Any]{
        return self.data
    }

}
