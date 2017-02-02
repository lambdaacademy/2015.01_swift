//
//  Vote.swift
//  Voter
//
//  Created by Krzysztof Profic on 14/12/14.
//  Copyright (c) 2014 Lambda Academy. All rights reserved.
//

import Foundation

// value type
enum Vote {
    case like(Date, String)
    case neutral(Date, String)
    case hate(Date, String)
    case none(Date, String)
    
    var description : String {
        switch(self) {
        case .like(_, _) :
            return "Like Vote"
        case .neutral(_, _) :
            return "Neutral Vote"
        case .hate(_, _) :
            return "Hate Vote"
        default :
            return "No Vote"
        }
    }
    
    func isKindOf(_ tryMe:Vote) -> Bool {
        switch ((self, tryMe)) {
        case (.like(_,_), .like(_,_)) :
            return true
        case (.neutral(_,_), .neutral(_,_)) :
            return true
        case (.hate(_,_), .hate(_,_)) :
            return true
        case (.none(_,_), .none(_,_)) :
            return true
        default :
            return false
        }
    }
    
    var isLike : Bool {
        switch(self) {
        case .like(_,_) :
            return true
        default :
            return false
        }
    }
    
    var isNeutral : Bool {
        switch(self) {
        case .neutral(_, _) :
            return true
        default :
            return false
        }
    }
    
    var isHate : Bool {
        switch(self) {
        case .hate(_, _) :
            return true
        default :
            return false
        }
    }
    
    var isNone : Bool {
        switch(self) {
        case .none(_,_) :
            return true
        default :
            return false
        }
    }
}
