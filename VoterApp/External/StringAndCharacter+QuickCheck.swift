//
//  StringAndCharacter+QuickCheck.swift
//  Voter
//
//  Created by Krzysztof Profic on 27/01/15.
//  Copyright (c) 2015 Lambda Academy. All rights reserved.
//

import Foundation

extension Character: Arbitrary {
    static func arbitrary() -> Character {
        return Character(UnicodeScalar(random(from: 65, to: 90)))
    }
    
    func smaller() -> Character? { return nil }
}

extension String: Smaller {
    func smaller() -> String? {
        return self.isEmpty ? nil
            : String(self.characters.dropFirst())
    }
}

extension String: Arbitrary {
    static func arbitrary() -> String {
        let randomLength = random(from: 0, to: 40)
        let randomCharacters = Array(0..<randomLength).map { _ in
            Character.arbitrary()
        }
        return randomCharacters.reduce("") { $0 + String($1) }
    }
}