//
//  Signature.swift
//  SwiftyRSA
//
//  Created by Loïs Di Qual on 9/19/16.
//  Copyright © 2016 Scoop. All rights reserved.
//

import Foundation

public struct Signature: Base64DataWrapper {
    public enum DigestType {
        case sha1
        case sha224
        case sha256
        case sha384
        case sha512

        var padding: Padding {
            switch self {
            case .sha1: return .PKCS1SHA1
            case .sha224: return .PKCS1SHA224
            case .sha256: return .PKCS1SHA256
            case .sha384: return .PKCS1SHA384
            case .sha512: return .PKCS1SHA512
            }
        }
    }

    public let data: Data
    public init(data: Data) {
        self.data = data
    }
}
extension Data {
    func digest(type: Signature.DigestType) -> Data {
        switch type {
        case .sha1: return sha1
        case .sha224: return sha224
        case .sha256: return sha256
        case .sha384: return sha384
        case .sha512: return sha512
        }
    }
}
