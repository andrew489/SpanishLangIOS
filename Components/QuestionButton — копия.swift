//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class QuestionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 0.271, green: 0.318, blue: 0.447, alpha: 1).cgColor
        
        layer.cornerRadius = 25
    
    
        
        setTitleColor(UIColor(red: 0.91, green: 0.941, blue: 0.914, alpha: 1), for: .normal)
    
        
        titleLabel?.font = UIFont(name: "SFProText-Regular", size: 17)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.99
        // Line height: 20 pt
        // (identical to box height)
        titleLabel?.textAlignment = .center
        setAttributedTitle(NSMutableAttributedString(string: "Далее", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle]), for: .normal)
    }

}
