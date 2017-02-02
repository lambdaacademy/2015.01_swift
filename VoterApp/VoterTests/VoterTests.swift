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
        XCTAssert(votes.elementsEqual(vm.votes, by: { $0.isKindOf($1)} ), "Casted and recieved vote arrays are not equal")
        
        votes = [Vote.like(Date(), ""), Vote.like(Date(), ""), Vote.hate(Date(), ""), Vote.neutral(Date(), "")]
        for v in votes {
            vm.makeVote(v)
        }
        print("votes: \(vm.votes)")
        XCTAssert(votes.elementsEqual(vm.votes, by: { $0.isKindOf($1)} ), "Casted and recieved vote arrays are not equal")
    }
    
    func testVoteManagerMedian() {
        var vm = VoteManager(tId: "1")
        XCTAssert(vm.median.isNone, "An empty Vote manager should return None as median")
        
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.neutral(Date(), ""))
        vm.makeVote(Vote.like(Date(), ""))
        XCTAssert(vm.median.isLike, "It should be Like here")
        
        vm = VoteManager(tId: "1")
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.hate(Date(), ""))
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.hate(Date(), ""))
        vm.makeVote(Vote.hate(Date(), ""))
        XCTAssert(vm.median.isHate, "It should be Hate here")
        
        vm = VoteManager(tId: "1")
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.neutral(Date(), ""))
        vm.makeVote(Vote.neutral(Date(), ""))
        vm.makeVote(Vote.neutral(Date(), ""))
        vm.makeVote(Vote.like(Date(), ""))
        vm.makeVote(Vote.neutral(Date(), ""))
        vm.makeVote(Vote.neutral(Date(), ""))
        XCTAssert(vm.median.isNeutral, "It should be Netural here")
    }
}
