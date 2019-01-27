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
    func testDispatchTime() {
        let seconds = Double(1)
        let now = DispatchTime.now() + seconds * Double(NSEC_PER_SEC) / Double(NSEC_PER_SEC)
        let dispatchTime = DispatchTime.delay(seconds:seconds)
        let after = DispatchTime.now() + seconds * Double(NSEC_PER_SEC) / Double(NSEC_PER_SEC)
        XCTAssert(now <= dispatchTime && dispatchTime <= after)
    }
    
    func testSubmitDaemon() {
        let unitTime = 0.1
        let times = 10
        var counter = 0
        let expectation = XCTestExpectation(description: "Run daemon closure a \(times) times.")
        Daemon.sharedInstance.submitBlock("RunAFewTimes", block: { (completion: @escaping () -> Void) in
            counter += 1
            guard counter < times else {
                expectation.fulfill()
                return
            }
            completion()
        }, active: true, seconds: unitTime)
        wait(for: [expectation], timeout: unitTime * Double(times + 1))
    }
    func testUpdateDaemon() {
        let firstDaemonUnitTime = 0.01
        let secondDaemonUnitTime = 0.1
        let firstDaemonName = "FirstDaemonName"
        let secondDaemonName = "SecondDaemonName"
        let fullFillSecondDaemon = XCTestExpectation(description: "FullFillSecondDaemon")
        fullFillSecondDaemon.assertForOverFulfill = true
        let activateSecondDaemon = XCTestExpectation(description: "ActivateSecondDaemon")
        Daemon.sharedInstance.submitBlock(firstDaemonName, block: { (_:@escaping () -> Void) in
            fullFillSecondDaemon.fulfill()
        }, active: false, seconds: firstDaemonUnitTime)
        Daemon.sharedInstance.submitBlock(secondDaemonName, block: { (_:@escaping () -> Void) in
            activateSecondDaemon.fulfill()
            Daemon.sharedInstance.updateBlock(firstDaemonName, active: true, seconds: nil)
        }, active: true, seconds: secondDaemonUnitTime)
        let timeout =  secondDaemonUnitTime + firstDaemonUnitTime * 2
        wait(for: [activateSecondDaemon, fullFillSecondDaemon], timeout: timeout, enforceOrder: true)
    }
}

