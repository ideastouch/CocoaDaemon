//
//  CocoaDaemonTests.swift
//  CocoaDaemonTests
//
//  Created by Gustavo Halperin on 1/17/19.
//  Copyright © 2019 iDeasTouch SA. All rights reserved.
//

import XCTest
@testable import CocoaDaemon

class CocoaDaemonTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDispatchTime() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let seconds = Double(10)
        let now = DispatchTime.now() + seconds * Double(NSEC_PER_SEC) / Double(NSEC_PER_SEC)
        let dispatchTime = DispatchTime.delay(seconds:10)
        let after = DispatchTime.now() + seconds * Double(NSEC_PER_SEC) / Double(NSEC_PER_SEC)
        XCTAssert(now <= dispatchTime && dispatchTime <= after)
    }
}

