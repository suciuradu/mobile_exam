//
//  ResponseModel.swift
//  MobileExam
//
//  Created by Suciu Radu on 08/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation

class MenuItem: Codable {
    var code: Int?
    var name: String?
    
    init(_ data: [String:Any]) {
        if let code = data["code"] as? Int {
            self.code = code
        }
        if let name = data["name"] as? String {
            self.name = name
        }
    }
    
    static func parseList(_ data: [[String : Any]]) -> [MenuItem] {
        var result = [MenuItem]()
        for entry in data {
            result.append(MenuItem.init(entry))
        }
        return result
    }
}
