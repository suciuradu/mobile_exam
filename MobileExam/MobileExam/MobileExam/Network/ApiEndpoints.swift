//
//  ApiEndpoints.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import Alamofire

class ApiEndpoints {
    
    public static let
    GET_MENU_ITEMS = ApiEndpoints.init(.get, Api.Endpoints.GET_MENU_ITEMS),
    POST_ORDER = ApiEndpoints.init(.post, Api.Endpoints.POST_ORDER)    
    public let path:String!
    public let method:HTTPMethod!
    
    private init(_ method:HTTPMethod, _ path:String) {
        self.method = method
        self.path = path
    }
    
    public func getUrl(pathParams:[String]?) -> String {
        var url = Api.Endpoints.BASE_URL + self.path
        if pathParams != nil {
            for param in pathParams! {
                url.append("/" + param)
            }
        }
        return url
    }
    
}
