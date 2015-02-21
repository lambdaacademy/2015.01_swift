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
    case Like(NSDate, String)
    case Neutral(NSDate, String)
    case Hate(NSDate, String)
    case None(NSDate, String)
    
    var description : String {
        switch(self) {
        case .Like(_, _) :
            return "Like Vote"
        case .Neutral(_, _) :
            return "Neutral Vote"
        case .Hate(_, _) :
            return "Hate Vote"
        default :
            return "No Vote"
        }
    }
    
    func isKindOf(tryMe:Vote) -> Bool {
        switch ((self, tryMe)) {
        case (.Like(_,_), .Like(_,_)) :
            return true
        case (.Neutral(_,_), .Neutral(_,_)) :
            return true
        case (.Hate(_,_), .Hate(_,_)) :
            return true
        case (.None(_,_), .None(_,_)) :
            return true
        default :
            return false
        }
    }
    
    var isLike : Bool {
        switch(self) {
        case .Like(_,_) :
            return true
        default :
            return false
        }
    }
    
    var isNeutral : Bool {
        switch(self) {
        case .Neutral(_, _) :
            return true
        default :
            return false
        }
    }
    
    var isHate : Bool {
        switch(self) {
        case .Hate(_, _) :
            return true
        default :
            return false
        }
    }
    
    var isNone : Bool {
        switch(self) {
        case .None(_,_) :
            return true
        default :
            return false
        }
    }
}