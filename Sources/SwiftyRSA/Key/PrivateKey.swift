//
//  PrivateKey.swift
//  SwiftyRSA
//
//  Created by Lois Di Qual on 5/17/17.
//  Copyright © 2017 Scoop. All rights reserved.
//

import Foundation

public struct PrivateKey: Key {
    public let reference: SecKey
    public let originalData: Data?
}
public extension PrivateKey {
    init(reference: SecKey) throws {
        guard Self.isValidKeyReference(reference, forClass: kSecAttrKeyClassPrivate) else {
            throw SwiftyRSAError.notAPrivateKey
        }
        self.reference = reference
        self.originalData = nil
    }
    init(data: Data) throws {
        self.originalData = data
        let dataWithoutHeader = try Self.stripKeyHeader(keyData: data)
        reference = try Self.addKey(dataWithoutHeader, isPublic: false)
    }
}
public extension PrivateKey {
    func pemString() throws -> String {
        let data = try self.data()
        let pem = data.format(withPemType: "RSA PRIVATE KEY")
        return pem
    }
}
