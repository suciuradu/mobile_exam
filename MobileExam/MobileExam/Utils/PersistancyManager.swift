//
//  PersistanceService.swift
//  MobileExam
//
//  Created by Suciu Radu on 08/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation

class PersistancyManager {
    
    static let shared = PersistancyManager()

    var modelArray = [MenuItem]()
    
    private static let
    MENU_ITEM = "menu_item",
    ORDER_ITEM = "order_item"

    
    public func set(model:[MenuItem]) {
        let modelArray = try! JSONEncoder().encode(model)
        UserDefaults.standard.set(modelArray, forKey: PersistancyManager.MENU_ITEM)
    }
    
    public static func getAll() -> [MenuItem]?{
        var modelArr = [MenuItem]()
        if let model = UserDefaults.standard.data(forKey: PersistancyManager.MENU_ITEM) {
            modelArr = try! JSONDecoder().decode([MenuItem].self, from: model)
        }
        return modelArr
    }
    
    public func setOrder(model:[OrderItem]) {
        let modelArray = try! JSONEncoder().encode(model)
        UserDefaults.standard.set(modelArray, forKey: PersistancyManager.ORDER_ITEM)
    }
    
    public static func getAllOrders() -> [OrderItem]?{
        var modelArr = [OrderItem]()
        if let model = UserDefaults.standard.data(forKey: PersistancyManager.ORDER_ITEM) {
            modelArr = try! JSONDecoder().decode([OrderItem].self, from: model)
        }
        return modelArr
    }
}

