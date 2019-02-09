//
//  Model.swift
//  MobileExam
//
//  Created by Suciu Radu on 08/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation

class OrderItem: Codable {
    var id: Int?
    var table: Int?
    var code: Int?
    var quantity: Int?
    var free: Bool?
    
    init() {}
    
    init(_ data: [String:Any]) {
        if let id = data["id"] as? Int {
            self.id = id
        }
        if let table = data["table"] as? Int {
            self.table = table
        }
        if let code = data["code"] as? Int {
            self.code = code
        }
        if let quantity = data["quantity"] as? Int {
            self.quantity = quantity
        }
        if let free = data["free"] as? Bool {
            self.free = free
        }
    }
}
