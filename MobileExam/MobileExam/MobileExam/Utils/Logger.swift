//
//  Logger.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import Foundation
import Crashlytics

class Logger {
    
    public static func log(_ items: Any...) {
        print("------\n", items, "\n------")
        Crashlytics.sharedInstance().recordError(NSError.init(domain: "\(items)", code: 0, userInfo: nil))
    }
    
    public static func localLog(_ items: Any...) {
        print("------\n", items, "\n------")
    }
    
    public static func testCrash() {
        Crashlytics.sharedInstance().crash()
    }
}
