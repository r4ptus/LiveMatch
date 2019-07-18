//
//  ViewControllerTest.swift
//  LiveMatchTests
//
//  Created by ema on 18.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import XCTest
@testable import LiveMatch

class ViewControllerTest: XCTestCase {
    func testInit() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ViewController") as? ViewController else { return }
        XCTAssert(viewController.searchBar != nil)
        XCTAssert(viewController.progressHUD != nil)
        XCTAssert(viewController.summoner == nil)
        XCTAssert(viewController.gameInfo == nil)
    }
}
