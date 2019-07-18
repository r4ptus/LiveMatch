//
//  SummonerProfileViewControllerTest.swift
//  LiveMatchTests
//
//  Created by ema on 18.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import XCTest
@testable import LiveMatch

class SummonerProfileViewControllerTest: XCTestCase {
    func testInit() {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SummonerProfileViewController")
            as? SummonerProfileViewController else { return }
        XCTAssert(viewController.summoner == nil)
        XCTAssert(viewController.summonerName != nil)
        XCTAssert(viewController.rankedEntries == nil)
        XCTAssert(viewController.summonerIcon != nil)
        XCTAssert(viewController.flex3Rank != nil)
        XCTAssert(viewController.flex5Ranked != nil)
        XCTAssert(viewController.soloQRank != nil)
    }
}
