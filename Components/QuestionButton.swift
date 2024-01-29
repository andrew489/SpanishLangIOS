//
//  RedButton.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import UIKit

class QuestionButton: UIButton {

    let label = UILabel()
    let imageView2 = UIImageView()
    static let heightT = 94
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
        label.font = UIFont(name: "SFProText-Medium", size: 15)
        label.textColor = .white
        label.frame  = CGRect(x: 40, y: 30, width: 237, height: 18)
        label.numberOfLines = 0
        self.addSubview(label)
        
        imageView2.layer.borderColor = UIColor.white.cgColor
        imageView2.layer.borderWidth = 3    
    }
    
    override func setText(text:String){
        label.text = text
    }
    override func setTag(id:Int){
        tag = id
    }
    
    override func setPosition(frame:[String:Int]){
        self.frame = CGRect(x: frame["x"]!, y:  frame["y"]!, width: frame["width"]!, height: frame["height"]!)
        imageView2.frame = CGRect(x: -29, y: (frame["height"]!/2)-29, width: 58, height: 58)
    }
    
    
    override func setLinkImage(link:String){
        self.addSubview(imageView2)
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
                self?.imageView2.layer.masksToBounds = true
                
            }
        }
    }
    

}
