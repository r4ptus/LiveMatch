//
//  GameDataTest.swift
//  LiveMatchTests
//
//  Created by ema on 10.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import XCTest
import LeagueAPI
@testable import LiveMatch

class GameDataTest: XCTestCase {
    var controller: ViewController!
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        controller = self.storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController

    }
    func testViewDidLoad(){
    }
}
