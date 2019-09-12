//
//  Data+SHA.swift
//  SwiftyRSA
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation
import CommonCrypto

extension Data {
    var sha1: Data {
        return SHA(CC_SHA1, CC_SHA1_DIGEST_LENGTH)
    }
    var sha224: Data {
        return SHA(CC_SHA224, CC_SHA224_DIGEST_LENGTH)
    }
    var sha256: Data {
        return SHA(CC_SHA256, CC_SHA256_DIGEST_LENGTH)
    }
    var sha384: Data {
        return SHA(CC_SHA384, CC_SHA384_DIGEST_LENGTH)
    }
    var sha512: Data {
        return SHA(CC_SHA512, CC_SHA512_DIGEST_LENGTH)
    }

    typealias SHAFunc = (UnsafeRawPointer?, CC_LONG, UnsafeMutablePointer<UInt8>?) -> UnsafeMutablePointer<UInt8>?
    private func SHA(_ closure: SHAFunc, _ count: Int32) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(count))
        _ = self.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return closure(bytes.baseAddress, CC_LONG(self.count), &digest)
        }
        return Data(bytes: &digest, count: Int(count))
    }
}
