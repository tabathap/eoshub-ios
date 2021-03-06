//
//  String+extension.swift
//  eosio-api
//
//  Created by kein on 2018. 7. 3..
//  Copyright © 2018년 kein. All rights reserved.
//

import Foundation

//MARK: Unicode conversion
extension String {
    
    var unicode: UInt32 {
        let scalars = unicodeScalars
        return scalars[scalars.startIndex].value
    }
}

//MARK: Range
extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
//MARK: Substring
extension String {
    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - self.count) + 1
        let indexStartOfText = self.index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = self.index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText..<indexEndOfText]
        return String(substring)
    }
}

extension String {
    subscript(value: NSRange) -> Substring {
        return self[value.lowerBound..<value.upperBound]
    }
}

extension String {
    subscript(value: CountableClosedRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...index(at: value.upperBound)]
        }
    }
    
    subscript(value: CountableRange<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(at: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(at: value.lowerBound)...]
        }
    }
    
    func index(at offset: Int) -> String.Index {
        return index(startIndex, offsetBy: offset)
    }
    
   
    
}

extension String {
    
    func substring(precision: Int) -> String {
        
        if count < precision {
            return self
        }
        
        return String(self[0...precision-1])
    }
    
    
    
    
    var decimalFormatted: String {
        var result = self
        for i in stride(from: count-3, to: 0, by: -3) {
            result.insert(",", at: index(startIndex, offsetBy: i))
        }
        return result
    }
    
    
    var plainFormatted: String {
        return replacingOccurrences(of: ",", with: "")
    }
    
    var dot4String: String {
        let comp = components(separatedBy: ".")
        if comp.count == 2 {
            let intPart = comp.first!
            let dotPart = comp.last!.substring(precision: 4)
            return intPart + "." + dotPart
        } else if count == 0 {
            return "0.0000"            
        } else {
            return self + ".0000"
        }
    }
    
    func fillZero(zeroCount: Int = 4) -> String {
        
        let postfix = [Character](repeating: Character("0"), count: zeroCount)
        
        let comp = components(separatedBy: ".")
        if comp.count == 2 {
            let intPart = comp.first!
            var dotPart = comp.last!.substring(precision: zeroCount)
            if dotPart.count < zeroCount {
                for _ in 0..<(zeroCount - dotPart.count) {
                    dotPart += "0"
                }
            }
            return intPart + "." + dotPart
        } else if count == 0 {
            return "0." + postfix
        } else {
            return self + "." + postfix
        }
    }
}

extension Int64 {
    var prettyPrinted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        return formattedNumber ?? "0"
    }
}

extension Double {
    var prettyPrinted: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value: self))
        return formattedNumber ?? "0"
    }
}


extension Data {
    var hexString: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}

