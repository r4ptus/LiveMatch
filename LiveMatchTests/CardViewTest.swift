//
//  CardViewTest.swift
//  LiveMatchTests
//
//  Created by ema on 18.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import XCTest
@testable import LiveMatch

class CardViewTest: XCTestCase {
    func testInit() {
        let cardView = CardView()
        XCTAssert(cardView.icon != nil)
        XCTAssert(cardView.view != nil)
        XCTAssert(cardView.queueType != nil)
        XCTAssert(cardView.rank != nil)
        XCTAssert(cardView.leaguePoints != nil)
    }
}
