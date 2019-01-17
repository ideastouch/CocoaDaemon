//
//  DispatchTime+Ext.swift
//  CocoaDaemon
//
//  Created by Gustavo Halperin on 1/17/19.
//  Copyright © 2019 iDeasTouch SA. All rights reserved.
//

import Foundation

extension DispatchTime {
    static func delay(seconds:Double) -> DispatchTime {
        let time = DispatchTime.now() + seconds * Double(NSEC_PER_SEC) / Double(NSEC_PER_SEC)
        return time
    }
}
