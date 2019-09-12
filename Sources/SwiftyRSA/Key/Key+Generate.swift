//
//  Key+Generate.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

public func generateRSAKeyPair(sizeInBits size: Int) throws -> (privateKey: PrivateKey, publicKey: PublicKey) {
    guard let tagData = UUID().uuidString.data(using: .utf8) else {
        throw SwiftyRSAError.stringToDataConversionFailed
    }

    let attributes: [CFString: Any] = [
        kSecAttrKeyType: kSecAttrKeyTypeRSA,
        kSecAttrKeySizeInBits: size,
        kSecPrivateKeyAttrs: [
            kSecAttrIsPermanent: true,
            kSecAttrApplicationTag: tagData
        ]
    ]

    var error: Unmanaged<CFError>?
    guard let privKey = SecKeyCreateRandomKey(attributes as CFDictionary, &error),
        let pubKey = SecKeyCopyPublicKey(privKey) else {
            throw SwiftyRSAError.keyGenerationFailed(error: error?.takeRetainedValue())
    }
    let privateKey = try PrivateKey(reference: privKey)
    let publicKey = try PublicKey(reference: pubKey)

    return (privateKey, publicKey)
}
