//
//  PublicKey.swift
//  SwiftyRSA
//
//  Created by Lois Di Qual on 5/17/17.
//  Copyright © 2017 Scoop. All rights reserved.
//

import Foundation
import CommonCrypto

public struct PublicKey: Key {
    public let reference: SecKey
    public let originalData: Data?
}
public extension PublicKey {
    init(reference: SecKey) throws {
        guard Self.isValidKeyReference(reference, forClass: kSecAttrKeyClassPublic) else {
            throw SwiftyRSAError.notAPublicKey
        }

        self.reference = reference
        self.originalData = nil
    }
    init(data: Data) throws {
        self.originalData = data
        let dataWithoutHeader = try Self.stripKeyHeader(keyData: data)
        reference = try Self.addKey(dataWithoutHeader, isPublic: true)
    }
}
public extension PublicKey {
    func pemString() throws -> String {
        let data = try self.data()
        let pem = data.format(withPemType: "RSA PUBLIC KEY")
        return pem
    }
}
public extension PublicKey {
    static let publicKeyRegex: NSRegularExpression? = {
        let publicKeyRegex = "(-----BEGIN PUBLIC KEY-----.+?-----END PUBLIC KEY-----)"
        return try? NSRegularExpression(pattern: publicKeyRegex, options: .dotMatchesLineSeparators)
    }()
    ///批量导入
    static func publicKeys(pemEncoded pemString: String) -> [PublicKey] {
        guard let publicKeyRegexp = publicKeyRegex, pemString.count > 0 else {
            return []
        }
        let all = NSRange(location: 0, length: pemString.count)

        let matches = publicKeyRegexp.matches(in: pemString, options: .init(rawValue: 0), range: all)

        let keys = matches.compactMap { result -> PublicKey? in

            let match = result.range(at: 1)
            let start = pemString.index(pemString.startIndex, offsetBy: match.location)
            let end = pemString.index(start, offsetBy: match.length)

            let thisKey = pemString[start..<end]

            return try? PublicKey(pemEncoded: String(thisKey))
        }

        return keys
    }
}
