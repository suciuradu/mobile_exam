//
//  MainViewModel.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation

class MainViewModel: NSObject {
    
    let menuItem = DynamicValue<[MenuItem]>([])
    let orderSuccess = DynamicValue<Bool>(false)
    let order = DynamicValue<OrderItem?>(nil)
    
    func getMenuItems(querry: String) {
        ApiClient.shared.getMenuItems(querry: querry) { (response) in
            if !response.isEmpty {
                self.menuItem.value.removeAll()
                self.menuItem.value.append(contentsOf: MenuItem.parseList(response))
            } else {
                self.menuItem.value = []
            }
        }
    }
    
    func postOrder(order: OrderItem) {
        ApiClient.shared.postOrder(order: order) { (success, order)  in
            if success {
                self.orderSuccess.value = success
                self.order.value = order
            } else {
                self.orderSuccess.value = success
                self.order.value = nil
            }
        }
    }

}
