//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class LevelButton: UIButton {
    
    static let heightT = 94
    let label = UILabel()
    let imageView2 = UIImageView()
    var indexBtn = 0;
    
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
        layer.borderColor = UIColor(red: 0.271, green: 0.318, blue: 0.447, alpha: 1).cgColor
        
        layer.cornerRadius = 25
    
        
        label.font = UIFont(name: "SFProText-Regular", size: 17)
        label.textColor = UIColor(red: 0.91, green: 0.941, blue: 0.914, alpha: 1)
        label.frame  = CGRect(x: 24, y: 16, width: 237, height: 18)
        label.numberOfLines = 0
        self.addSubview(label)
        
        self.addSubview(imageView2)
        
    }
    
    override func setText(text:String){
        label.text = text
    }
    
    override func setTag(id:Int){
        tag = id
    }
    
    override func getHeight() -> Int {
        return 94-28
    }
    
    override func setPosition(frame:[String:Int]){
        self.frame = CGRect(x: 24, y:  frame["y"]!, width: frame["width"]!, height: 50)
        imageView2.frame  = CGRect(x: frame["width"]!-56-24, y: 14, width: 56, height: 24)
    }
    
    override func setIndex(index:Int){
        self.indexBtn = index
        imageView2.image = UIImage(named: "l" + String(self.indexBtn))
    }
}
