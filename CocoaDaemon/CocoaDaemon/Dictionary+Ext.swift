//
//  Dictionary+Ext.swift
//  CocoaDaemon
//
//  Created by Gustavo Halperin on 1/17/19.
//  Copyright © 2019 iDeasTouch SA. All rights reserved.
//

import Foundation

extension Dictionary /* <Key, Value> */ {
    func hasValue (_ key:Key) -> Bool {
        guard let _ = self[key] else { return false }
        return true
    }
}
