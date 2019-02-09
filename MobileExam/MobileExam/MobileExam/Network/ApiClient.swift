//
//  ApiClient.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient {
    
    static var shared = ApiClient()

    private init() {}
    
    func getMenuItems(querry: String, completion: @escaping(_ response: [[String:Any]])->()) {
        
        let url = ApiEndpoints.GET_MENU_ITEMS.getUrl(pathParams: nil)
        let method = ApiEndpoints.GET_MENU_ITEMS.method!
        let parameters = [
            "q" : querry
        ]
        
        Logger.localLog("REQUEST: ", method.rawValue, "\n URL:", url, "\n PARAMETERS:", parameters)
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: URLEncoding(destination: .queryString),
                          headers: nil).validate().responseJSON { (response) in
                            Logger.log("RESPONSE:",response.value as Any)
                            guard let data = response.result.value as? [[String:Any]] else {return}
                            completion(data)
                            
        }
    }
    
    func postOrder(order: OrderItem, completion: @escaping(_ success:Bool, _ order: OrderItem)->()) {
        
        let url = ApiEndpoints.POST_ORDER.getUrl(pathParams: nil)
        let method = ApiEndpoints.POST_ORDER.method!
        let body = [
            "code": order.code,
            "quantity": order.quantity,
            "table": 1,
            "free": order.free
            ] as [String : Any]
        
        Logger.localLog("REQUEST: ", method.rawValue, "\nURL:", url)
        Alamofire.request(url,
                          method: method,
                          parameters: body,
                          encoding: JSONEncoding.default,
                          headers: nil).validate().responseJSON { (response) in
                            Logger.log("RESPONSE:",response)
                            if response.error == nil {
                                guard let data = response.value as? [String:Any] else {return}
                                let order = OrderItem.init(data)
                                completion(true, order)
                            } else {
                                let order = OrderItem()
                                completion(false, order)
                            }
        }
    }

}
