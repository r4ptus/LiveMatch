//
//  PlayerDataViewControllerTest.swift
//  LiveMatchTests
//
//  Created by ema on 18.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import XCTest
@testable import LiveMatch

class PlayerDataViewControllerTest: XCTestCase {
    func testInit() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PlayerDataViewController")
            as? PlayerDataViewController else { return }
        XCTAssert(viewController.summoner == nil)
        XCTAssert(viewController.tableView != nil)
        XCTAssert(viewController.rankedEntries == nil)
        XCTAssert(!viewController.soloEntry)
        XCTAssert(!viewController.flex3Entry)
        XCTAssert(!viewController.flex5Entry)
    }
}
