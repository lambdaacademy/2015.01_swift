//
//  QuickCheckTests.swift
//  Voter
//
//  Created by Krzysztof Profic on 27/01/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import XCTest



// Check calls check withing assertion clausure
func Check<X: Arbitrary>(prop: X -> Bool, desc: String) {
    XCTAssert(check(desc, prop), desc)
}

func Check<X: Arbitrary, Y: Arbitrary>(prop: (X, Y) -> Bool, desc: String) {
    XCTAssert(check(desc, prop), desc)
}

class QuickCheckTests: XCTestCase {
    func testMath() {
        // plus is cummutative
    }
    
    func testVoteManager() {
        
    }
    
}
