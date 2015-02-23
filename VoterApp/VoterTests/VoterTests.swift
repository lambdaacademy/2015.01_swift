//
//  VoterTests.swift
//  VoterTests
//
//  Created by Krzysztof Profic on 14/12/14.
//  Copyright (c) 2014 Lambda Academy. All rights reserved.
//

import UIKit
import XCTest

class VoterTests: XCTestCase {
    
    func testMath() {
        XCTAssert(1+1==2, "we can't do math?")
    }
    
    func testVoteManagerAccumulatesVotes() {
        let vm = VoteManager(tId: "1")
        
        var votes: [Vote] = []
        XCTAssert(equal(votes, vm.votes, { $0.isKindOf($1)} ), "Casted and recieved vote arrays are not equal")
        
        votes = [Vote.Like(NSDate(), ""), Vote.Like(NSDate(), ""), Vote.Hate(NSDate(), ""), Vote.Neutral(NSDate(), "")]
        for v in votes {
            vm.makeVote(v)
        }
        println("votes: \(vm.votes)")
        XCTAssert(equal(votes, vm.votes, { $0.isKindOf($1)} ), "Casted and recieved vote arrays are not equal")
    }
    
    func testVoteManagerMedian() {
        var vm = VoteManager(tId: "1")
        XCTAssert(vm.median.isNone, "An empty Vote manager should return None as median")
        
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Neutral(NSDate(), ""))
        vm.makeVote(Vote.Like(NSDate(), ""))
        XCTAssert(vm.median.isLike, "It should be Like here")
        
        vm = VoteManager(tId: "1")
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Hate(NSDate(), ""))
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Hate(NSDate(), ""))
        vm.makeVote(Vote.Hate(NSDate(), ""))
        XCTAssert(vm.median.isHate, "It should be Hate here")
        
        vm = VoteManager(tId: "1")
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Neutral(NSDate(), ""))
        vm.makeVote(Vote.Neutral(NSDate(), ""))
        vm.makeVote(Vote.Neutral(NSDate(), ""))
        vm.makeVote(Vote.Like(NSDate(), ""))
        vm.makeVote(Vote.Neutral(NSDate(), ""))
        vm.makeVote(Vote.Neutral(NSDate(), ""))
        XCTAssert(vm.median.isNeutral, "It should be Netural here")
    }
}
