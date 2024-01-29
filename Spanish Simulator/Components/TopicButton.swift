//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class TopicButton: UIButton {

    let label = UILabel()
    let completeLbl = UILabel()
    let imageView2 = UIImageView()
    let imageViewTopic = UIImageView()
    static let heightT = 94
    var data:[String:Any] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
        
        imageView2.layer.cornerRadius = imageView2.bounds.height/2
    }
    
    
    func setupButton() {
        contentMode = .scaleAspectFill
        backgroundColor = UIColor(red: 0.364, green: 0.418, blue: 0.605, alpha: 1)
        layer.cornerRadius = 20
        label.font = UIFont(name: "SFProText-Regular", size: 15)
        label.textColor = .white
        label.frame  = CGRect(x: 40, y: 16, width: frame.width-20, height: 18)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        
        self.addSubview(label)
        

        completeLbl.frame  = CGRect(x: 40, y: 16, width: frame.width-20, height: 18)
        completeLbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        completeLbl.font = UIFont(name: "SFProText-Regular", size: 11)
        self.addSubview(completeLbl)
        
        
    }
    
    override func setData(data:[String:Any]){
        self.data = data
//        completeLbl.text = data["name"] as? String
        if(data["meta"] != nil){
            var x = 40
            for e in (data["meta"] as! [String]) {
                let m = UILabel(frame: CGRect(x: x, y: 42, width: 70, height: 20))
                m.text = e;
                m.layer.backgroundColor = UIColor(red: 0.423, green: 0.469, blue: 0.622, alpha: 1).cgColor
                m.layer.cornerRadius = 4
                m.textColor = .white
                m.font = UIFont(name: "SFProText-Regular", size: 11)
                m.sizeToFit()
                
                m.frame = CGRect(x: x, y: 50, width: Int(m.bounds.width) + 12, height: 20)
                m.textAlignment = .center
            
                self.addSubview(m)
                x += Int(m.bounds.width) + 8
            }
        }
        if(data["completeCount"] != nil && (data["completeCount"] as! Int) > 0){
            if((data["completeCount"] as! Int) < (data["questions_count"]  as! Int)) {
                let complete = String((data["completeCount"] as! Int))
                completeLbl.text = "Пройдено \(complete) из \(data["questions_count"]  as! Int)"
                completeLbl.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                completeLbl.font = UIFont(name: "SFProText-Regular", size: 11)

            } else {
                // Create Attachment
                let imageAttachment = NSTextAttachment()
                imageAttachment.image = UIImage(named:"done")
                // Set bound to reposition
                imageAttachment.bounds = CGRect(x: -4, y: -5, width: 16, height: 16)
                // Create string with attachment
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                // Initialize mutable string
                let completeText = NSMutableAttributedString(string: "")
                // Add image to mutable string
                completeText.append(attachmentString)
                // Add your text to mutable string
                let textAfterIcon = NSAttributedString(string: " Пройден")
                completeText.append(textAfterIcon)
                completeLbl.textColor = .white
                completeLbl.font = UIFont(name: "SFProText-Regular", size: 11)

                completeLbl.attributedText = completeText
                
            }
        }
    }
    
    override func setText(text:String){
        label.text = text
        
        self.label.frame =  CGRect(x: 40, y: 16, width:  self.frame.width - 70 - 20 - 40 , height: self.label.font.pointSize * (CGFloat(Int(Int((self.label.text!.count > 20 ? self.label.text?.count : 1) ?? 1)/20))+1.4))
    }
    
    override func setTag(id:Int){
        tag = id
    }
    override func setPosition(frame:[String:Int]){
        self.frame = CGRect(x: 54, y:  frame["y"]!, width: frame["width"]! - 6 - 24, height: 92)
        imageView2.layer.frame = CGRect(x: 10, y: 10, width: 38, height: 38)
        imageViewTopic.layer.frame = CGRect(x: -29, y: (frame["height"]!/2)-29, width: 58, height: 58)
        imageViewTopic.layer.cornerRadius = 29
        imageViewTopic.contentMode = .scaleAspectFill
        imageViewTopic.layer.masksToBounds = true
        
        imageViewTopic.backgroundColor = .white
        
        imageViewTopic.backgroundColor = UIColor(patternImage: UIImage(named:"topicBg")!)
        completeLbl.frame  = CGRect(x: 40, y: Int(self.frame.height)-29, width: frame["width"]! - 70 - 20, height: 18)
        
        self.label.frame =  CGRect(x: 40, y: 16, width: self.frame.width - 70 - 20 , height: 18)
    }
    
    override func setLinkImage(link:String){
        self.addSubview(imageViewTopic)
        
        imageViewTopic.addSubview(imageView2)
        downloadImage(from:  URL(string:link)!)
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

                self?.imageView2.image = img
                self?.imageView2.layer.cornerRadius = 29
                self?.imageView2.contentMode = .scaleAspectFill
                self?.imageView2.layer.masksToBounds = true
            }
        }
    }
    
    override func getHeight() -> Int{
        return 92+12
    }
}
