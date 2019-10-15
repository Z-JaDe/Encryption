//
//  Dictionary.swift
//  SNKit
//
//  Created by ZJaDe on 2018/5/30.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

extension Dictionary where Key: Comparable {
    public func rsaEncryptedStr(_ publicKey: String) -> String? {
        return self.sortedParamsStr.rsaEncryptedStr(publicKey)
    }
}
