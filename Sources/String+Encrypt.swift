//
//  String+Encrypt.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/10/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CryptoSwift
extension String {
    public var md5UpperString: String {
        return md5().uppercased()
    }
    public var md5LowString: String {
        return md5()// .lowercased()
    }
}
