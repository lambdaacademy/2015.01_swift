//
//  QuickCheckTests.swift
//  Voter
//
//  Created by Krzysztof Profic on 27/01/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import XCTest



// Check calls check withing assertion clausure
func Check<X: Arbitrary>(_ prop: (X) -> Bool, desc: String) {
    XCTAssert(check(desc, prop: prop), desc)
}

func Check<X: Arbitrary, Y: Arbitrary>(_ prop: (X, Y) -> Bool, desc: String) {
    XCTAssert(check(desc, prop: prop), desc)
}

class QuickCheckTests: XCTestCase {
    func testMath() {
        // plus is cummutative
    }
    
    func testVoteManager() {
        
    }
    
}
