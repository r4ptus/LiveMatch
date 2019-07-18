//
//  GameDataViewControllerTest.swift
//  LiveMatchTests
//
//  Created by ema on 18.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import XCTest
@testable import LiveMatch

class GameDataViewControllerTest: XCTestCase {
    func testInit() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GameDataViewController")
            as? GameDataViewController else { return }
        XCTAssert(viewController.teamRed?.count == 0)
        XCTAssert(viewController.teamBlue?.count == 0)
        XCTAssert(viewController.bannedCRed?.count == 0)
        XCTAssert(viewController.bannedCBlue?.count == 0)
        XCTAssert(viewController.tableView != nil)
    }
}
