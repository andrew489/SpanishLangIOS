//
//  TextField.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 30.10.2023.
//

import Foundation
import UIKit

class TextField: UITextField {
    
    var placeholderLabel:UILabel?=nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
        
    public func placeholderHidden(){
        placeholderLabel?.isHidden = true
        
        print("isHidden=");
        print(placeholderLabel?.isHidden as? String)
    }
            
    func setupButton(){
        
        layer.cornerRadius = 16
        layer.borderWidth = 2
        textColor = .white
        
        font = UIFont(name: "Inter-Regular", size: 16)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.83
     
       

    
        layer.borderColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1).cgColor
        addTarget(self, action: #selector(yourHandler(textField:)), for: .editingChanged)
    }

    open func setLabel() {
        placeholderLabel = UILabel();
        placeholderLabel?.text = placeholder
        placeholderLabel?.font = UIFont(name: "Inter-Regular", size: 12)
       
        placeholderLabel?.sizeToFit()
        self.addSubview(placeholderLabel!)
        placeholderLabel!.frame.origin = CGPoint(x: 16, y: 12)
        placeholderLabel!.textColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)
        placeholderLabel!.isHidden = !(text!.count > 0)
    }

    open func changeLabel(str:String) {
        placeholderLabel?.text = str
        placeholder = str
        placeholderLabel!.isHidden = !(text!.count > 0)
    }
    
    let padding = UIEdgeInsets(top: 30, left: 16, bottom: 10, right: 16)
    let padding2 = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: (placeholderLabel != nil) ? padding : padding2)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding2)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: (placeholderLabel != nil) ? padding : padding2)
    }
    
    override var isEnabled: Bool {
        willSet {
            textColor = newValue ? .white : UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)
            
        }
    }
    @objc final private func yourHandler(textField: UITextField) {
        DispatchQueue.main.async {
            self.placeholderLabel?.isHidden = !(self.text!.count > 0)
        }
    }

}
