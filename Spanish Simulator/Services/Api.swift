//
//  Api.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 28.10.2023.
//

import Foundation
import UIKit

class Api {
    static var URI = "https://app-ensina-me.ru/api/"
    static var MAIN_URI = "https://app-ensina-me.ru/"
    
    enum Errors: Error {
        case notAuthenticated
        case custom(message:String)
    }
    
    private let boundary: String = UUID().uuidString
    public func post(url:String,parameters:[String:Any], completion: @escaping (Result<[String:Any],Errors>) -> Void) -> Void{
        
        let request = MultipartFormDataRequest(url: URL(string: String(format: Api.URI + url))!)
    

        for (_, element) in parameters.enumerated() {
            request.addTextField(named: element.key, value: element.value as! String)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data,error == nil else {
                completion(.failure(.custom(message:"Нет данных")))
                return
            }
            
            guard let res = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                completion(.failure(.custom(message:"Ошибка в данных")))
                return
            }
            
            completion(.success(res))
            
        }.resume()
    }
    
    public func get(url:String,completion: @escaping (Result<[String:Any],Errors>) -> Void) -> Void{
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "token") ?? ""
    
        let Url = String(format: Api.URI + url)
        
        guard let serviceUrl = URL(string: Url) else { return }
        
        var request = URLRequest(url: serviceUrl)
    
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        
        request.timeoutInterval = 8
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
          
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode==401){
                    completion(.failure(.notAuthenticated))
                    return
                }
            }
            guard let data = data,error == nil else {
                completion(.failure(.custom(message:"Нет данных")))
                return
            }
            
            guard let res = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                completion(.failure(.custom(message:"Ошибка в данных")))
                return
            }
            
            completion(.success(res))
            
        }.resume()
    }
    
    func uploadFile(file:UIImage, fileName: String, fileExtension: String){
        var mimeType = "image/png"
        print(file)
        print(fileExtension)
        if fileExtension == "PDF" {
            mimeType = "application/pdf"
        }
        let url = Api.URI + "picture-update"

        let request = MultipartFormDataRequest(url: URL(string: url)!)
        let file = cropToBounds(image: file,width: 64,height: 64)
        request.addDataField(fieldName:  "avatar", fileName: fileName, data: file, mimeType: mimeType)
       
        URLSession.shared.dataTask(with: request, completionHandler: {data,urlResponse,error in
          
            guard let res = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any] else {
                print("ERROR")
                return
            }
            
            let defaults = UserDefaults.standard
            print(res)
            if((res["avatar_url"]) != nil) {
                defaults.set(res["avatar_url"] as! String,forKey: "avatar")
            }

        }).resume()
    }
    func cropToBounds(image: UIImage, width: Double, height: Double) -> Data {
        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image.pngData()!
    }
    
    func matches(for regex: String, in text: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            let res = results.map {
                String(text[Range($0.range, in: text)!])
            }
           
            return res.joined(separator:"")
            
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return ""
        }
    }
}

