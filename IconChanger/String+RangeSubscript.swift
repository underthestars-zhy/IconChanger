//
//  String+RangeSubscript.swift
//  Endless (FileProvider iOS)
//
//  Created by 朱浩宇 on 2022/1/10.
//

import Foundation

extension String {
    subscript(range: ClosedRange<Int>) -> String? {
        return String(self[index(startIndex, offsetBy: range.lowerBound)...index(startIndex, offsetBy: range.upperBound)])
    }
    
    subscript(range: Range<Int>) -> String? {
        return String(self[index(startIndex, offsetBy: range.lowerBound)...index(startIndex, offsetBy: range.upperBound - 1)])
    }
    
    subscript(i: Int) -> String? {
        return String(self[index(startIndex, offsetBy: i)])
    }
}
