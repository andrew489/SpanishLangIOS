//
//  Trainer.swift
//  Spanish Simulator
//
//  Created by Андрей Обоскалов on 06.11.2023.
//

import Foundation

struct Trainer:Codable {
    var id:Int;
    var parent_id:Int;
    var picture:String?;
    var module:Int;
    var name:String
    var comment:String?
    var correct:Int
    var created_at:String?
    var updated_at:String?
    var order:Int
    var linkImage:String?
    var component:String?
}
