//
//  ClearMessage+Sign.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

extension ClearMessage {
    public func signed(with key: PrivateKey, digestType: Signature.DigestType) throws -> Signature {
        let digest = data.digest(type: digestType)
        let blockSize = SecKeyGetBlockSize(key.reference)
        let maxChunkSize = blockSize - 11

        guard digest.count <= maxChunkSize else {
            throw SwiftyRSAError.invalidDigestSize(digestSize: digest.count, maxChunkSize: maxChunkSize)
        }
        let digestBytes = digest.bytes
        var signatureBytes = [UInt8](repeating: 0, count: blockSize)
        var signatureDataLength = blockSize

        let status = SecKeyRawSign(key.reference, digestType.padding, digestBytes, digestBytes.count, &signatureBytes, &signatureDataLength)

        guard status == noErr else {
            throw SwiftyRSAError.signatureCreateFailed(status: status)
        }

        return Signature(data: Data(signatureBytes))
    }
    public func verify(with key: PublicKey, signature: Signature, digestType: Signature.DigestType) throws -> Bool {
        let digestBytes = data.digest(type: digestType).bytes
        let signatureBytes = signature.data.bytes

        let status = SecKeyRawVerify(key.reference, digestType.padding, digestBytes, digestBytes.count, signatureBytes, signatureBytes.count)

        if status == errSecSuccess {
            return true
        } else if status == -9809 {
            return false
        } else {
            throw SwiftyRSAError.signatureVerifyFailed(status: status)
        }
    }
}
