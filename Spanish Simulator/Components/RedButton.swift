//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class RedButton: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        
        layer.cornerRadius = 28
        contentMode = .scaleAspectFill
        
        setBackgroundImage(UIImage(named: "redBtn"), for: .normal)
        setBackgroundImage(nil, for: .disabled)
 
        
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1), for: .disabled)
        
        titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 16)
    
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.84
        // Line height: 16 pt
        // (identical to box height)
        titleLabel?.textAlignment = .center
        setAttributedTitle(NSMutableAttributedString(string: "Далее", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
    }
    

}
