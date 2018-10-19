//
//  String+Encrypt.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/10/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

extension String {
    public var md5String: String {
        return FSOpenSSL.md5(from: self)
    }
    public var md5LowString: String {
        return self.md5String.lowercased()
    }
}
