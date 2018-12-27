//
//  Dictionary.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 17/2/8.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

extension Dictionary {
    public var paramsStr: String {
        return self.joined(separator: "&")
    }
    public func joined(separator: String, keyValueSeparator: String = "=") -> String {
        return map {"\($0.key)\(keyValueSeparator)\($0.value)"}.joined(separator: separator)
    }
}
extension Dictionary where Key: Comparable {
    public var sortedParamsStr: String {
        return self.sorted(by: {$0.key < $1.key}).map {($0, $1)}.paramsStr
    }
}
extension Array where Element == (Hashable, Any) {
    public var paramsStr: String {
        return self.joined(separator: "&")
    }
    public func joined(separator: String, keyValueSeparator: String = "=") -> String {
        return map {"\($0.0)\(keyValueSeparator)\($0.1)"}.joined(separator: separator)
    }
}
