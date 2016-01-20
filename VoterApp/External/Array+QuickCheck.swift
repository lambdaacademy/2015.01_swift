//
//  Array+QuickCheck.swift
//  Voter
//
//  Created by Krzysztof Profic on 27/01/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import Foundation

func arbitraryArray<X: Arbitrary>() -> [X] {
    let randomLength = Int(arc4random() % 50)
    let arr: [X] = Array(0..<randomLength).map{ _ in return X.arbitrary() }
    return arr
}

func check<X: Arbitrary>(message: String, prop: [X] -> Bool) -> (Bool) {
    let instance = ArbitraryI(arbitrary: arbitraryArray, smaller: { (x: [X]) in x.smaller() })
    return checkHelper(instance, prop: prop, message: message)
}

extension Array: Smaller {
    func smaller() -> [Element]? {
        // TODO
        return nil
    }
    
}