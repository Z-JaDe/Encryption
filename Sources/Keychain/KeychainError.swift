//
//  KeychainError.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

struct KeychainError: RawRepresentable, Equatable {
    let rawValue: OSStatus
    init(rawValue: OSStatus) {
        self.rawValue = rawValue
    }
    static let badArguments: KeychainError = -1001
    static let unimplemented: KeychainError = KeychainError(rawValue: errSecUnimplemented)
    static let param: KeychainError = KeychainError(rawValue: errSecParam)
    static let allocate: KeychainError = KeychainError(rawValue: errSecAllocate)
    static let notAvailable: KeychainError = KeychainError(rawValue: errSecNotAvailable)
    static let duplicateItem: KeychainError = KeychainError(rawValue: errSecDuplicateItem)
    static let itemNotFound: KeychainError = KeychainError(rawValue: errSecItemNotFound)
    static let interactionNotAllowed: KeychainError = KeychainError(rawValue: errSecInteractionNotAllowed)
    static let decode: KeychainError = KeychainError(rawValue: errSecDecode)
    static let authFailed: KeychainError = KeychainError(rawValue: errSecAuthFailed)
}
extension KeychainError: ExpressibleByIntegerLiteral {
    init(integerLiteral value: OSStatus) {
        self.rawValue = value
    }
}
extension KeychainError: LocalizedError, CustomDebugStringConvertible {
    var debugDescription: String {
        return self.localizedDescription
    }
    var localizedDescription: String {
        switch self {
        case .badArguments: return "Some of the arguments were invalid"
            case .unimplemented: return "Function or operation not implemented"
            case .param: return "One or more parameters passed to a function were not valid"
            case .allocate: return "Failed to allocate memory"
            case .notAvailable: return "No keychain is available. You may need to restart your computer"
            case .duplicateItem: return "The specified item already exists in the keychain"
            case .itemNotFound: return "The specified item could not be found in the keychain"
            case .interactionNotAllowed: return "User interaction is not allowed"
            case .decode: return "Unable to decode the provided data"
            case .authFailed: return "The user name or passphrase you entered is not correct"
        default:
            return "Refer to SecBase.h for description"
        }
    }
}
