//
//  QuickCheckHelpers.swift
//  Voter
//
//  Created by Krzysztof Profic on 27/01/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import Foundation

func iterateWhile<A>(_ condition: (A) -> Bool, initialValue: A, next: (A) -> A?) -> A {
    if let x = next(initialValue) {
        if condition(x) {
            return iterateWhile(condition, initialValue: x, next: next)
        }
    }
    return initialValue
}

func random(from: Int, to: Int) -> Int {
    return from + (Int(arc4random()) % (to-from))
}
