//
//  KeychainQueryInfo.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

public struct KeychainQueryInfo {
    typealias Dict = [CFString: Any]
    public var account: String = ""
    public var service: String = ""
    public var accessGroup: String = ""
    public var passwordData: Data = Data()
    public var label: String = ""
    public var synchronizationMode: KeychainQuery.SynchronizationMode = .any

    var searchQuery: Dict {
        var result = Dict()
        result[kSecClass] = kSecClassGenericPassword
        result.saveIfNotEmpty(kSecAttrService, self.service)
        result.saveIfNotEmpty(kSecAttrAccount, self.account)
        result.saveIfNotEmpty(kSecAttrAccessGroup, self.accessGroup)
        switch self.synchronizationMode {
        case .any:
            result[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        case .no:
            result[kSecAttrSynchronizable] = false
        case .yes:
            result[kSecAttrSynchronizable] = true
        }
        return result
    }
    func savePasswordInfo(in dict: inout Dict) {
        dict[kSecValueData] = self.passwordData
    }
    func saveAccessibilityType(in dict: inout Dict) {
        dict[kSecAttrAccessible] = Keychain.accessibilityType
    }
    func saveLabel(in dict: inout Dict) {
        dict[kSecAttrLabel] = self.label
    }
}
extension KeychainQueryInfo {
    var password: String {
        get {return String(data: passwordData, encoding: .utf8) ?? ""}
        set {self.passwordData = newValue.data(using: .utf8) ?? Data()}
    }
}
extension KeychainQueryInfo.Dict {
    mutating func saveIfNotEmpty(_ key: Key, _ value: String) {
        if value.isEmpty == false {
            self[key] = value
        }
    }
    var cf: CFDictionary {
        return self as CFDictionary
    }
}
