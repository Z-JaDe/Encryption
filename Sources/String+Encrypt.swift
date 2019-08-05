//
//  String+Encrypt.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/10/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import CommonCrypto
extension String {
    public var md5String: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        #if swift(>=5.0)
        _ = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return CC_MD5(bytes.baseAddress, CC_LONG(data.count), &digest)
        }
        #else
        _ = data.withUnsafeBytes { bytes in
            return CC_MD5(bytes, CC_LONG(data.count), &digest)
        }
        #endif
        return digest.reduce(into: "") { $0 += String(format: "%02x", $1) }
    }
    public var md5LowString: String {
        return self.md5String.lowercased()
    }
}
