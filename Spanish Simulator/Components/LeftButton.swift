//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class LeftButton: UIButton {

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        
   
        frame = CGRect(x: 18, y: 50, width: 36, height: 36)
        setImage(UIImage(named: "leftBtn"), for: .normal)
        configuration = UIButton.Configuration.gray()
       
    }
   
}
