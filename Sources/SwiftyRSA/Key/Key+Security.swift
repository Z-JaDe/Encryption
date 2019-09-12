//
//  Key+Se.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation
import Security

extension Key {
    /// 验证key类型是否正确
    static func isValidKeyReference(_ reference: SecKey, forClass requiredClass: CFString) -> Bool {
        let attributes = SecKeyCopyAttributes(reference) as? [CFString: Any]
        guard let keyType = attributes?[kSecAttrKeyType] as? String, let keyClass = attributes?[kSecAttrKeyClass] as? String else {
            return false
        }
        let isRSA = keyType == (kSecAttrKeyTypeRSA as String)
        let isValidClass = keyClass == (requiredClass as String)
        return isRSA && isValidClass
    }
    /// Security根据Data生成SecKey
    static func addKey(_ keyData: Data, isPublic: Bool) throws -> SecKey {
        let keyClass = isPublic ? kSecAttrKeyClassPublic : kSecAttrKeyClassPrivate

        let sizeInBits = keyData.count * 8
        let keyDict: [CFString: Any] = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: keyClass,
            kSecAttrKeySizeInBits: sizeInBits,
            kSecReturnPersistentRef: true
        ]

        var error: Unmanaged<CFError>?
        guard let key = SecKeyCreateWithData(keyData as CFData, keyDict as CFDictionary, &error) else {
            throw SwiftyRSAError.keyCreateFailed(error: error?.takeRetainedValue())
        }
        return key
    }
    static func stripKeyHeader(keyData: Data) throws -> Data {
        let node: Asn1Parser.Node
        do {
            node = try Asn1Parser.parse(data: keyData)
        } catch {
            throw SwiftyRSAError.asn1ParsingFailed
        }

        // Ensure the raw data is an ASN1 sequence
        guard case .sequence(let nodes) = node else {
            throw SwiftyRSAError.invalidAsn1RootNode
        }

        // Detect whether the sequence only has integers, in which case it's a headerless key
        let onlyHasIntegers = nodes.filter { node -> Bool in
            if case .integer = node {
                return false
            }
            return true
            }.isEmpty

        // Headerless key
        if onlyHasIntegers {
            return keyData
        }

        // If last element of the sequence is a bit string, return its data
        if let last = nodes.last, case .bitString(let data) = last {
            return data
        }

        // If last element of the sequence is an octet string, return its data
        if let last = nodes.last, case .octetString(let data) = last {
            return data
        }

        // Unable to extract bit/octet string or raw integer sequence
        throw SwiftyRSAError.invalidAsn1Structure
    }
}
