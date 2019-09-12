//
//  KeychainQuery.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation
@dynamicMemberLookup
public struct KeychainQuery {
    typealias Dict = KeychainQueryInfo.Dict
    public enum SynchronizationMode {
        case any
        case no
        case yes
    }
    private var model: KeychainQueryInfo = KeychainQueryInfo()
    
    init() {}
    init(service: String, account: String) {
        self.service = service
        self.account = account
    }
}
extension KeychainQuery {
    public func save() throws {
        if self.service.isEmpty || self.account.isEmpty || self.passwordData.isEmpty {
            throw KeychainError.badArguments
        }
        var status: OSStatus
        let searchQuery = self.model.searchQuery
        status = search(with: searchQuery)
        if status == errSecSuccess {
            var query: Dict = [:]
            model.savePasswordInfo(in: &query)
            model.saveAccessibilityType(in: &query)
            status = SecItemUpdate(searchQuery.cf, query.cf)
        } else if status == errSecItemNotFound {
            var query: Dict = self.model.searchQuery
            model.saveLabel(in: &query)
            model.savePasswordInfo(in: &query)
            model.saveAccessibilityType(in: &query)
            status = SecItemAdd(query as CFDictionary, nil)
        }
        try checkStatus(status)
    }
    public func deleteItem() throws {
        if self.service.isEmpty || self.account.isEmpty {
            throw KeychainError.badArguments
        }
        var status: OSStatus
        let searchQuery = self.model.searchQuery.cf
        status = SecItemDelete(searchQuery)
        try checkStatus(status)
    }
}
extension KeychainQuery {
    public func fetchAll() throws -> [[String: Any]] {
        var query: Dict = self.model.searchQuery
        model.saveAccessibilityType(in: &query)

        return try searchAll(with: &query)
    }
    public mutating func fetch() throws {
        if self.service.isEmpty || self.account.isEmpty {
            throw KeychainError.badArguments
        }
        var query: Dict = self.model.searchQuery
        self.passwordData = try searchOne(with: &query)
    }
}
extension KeychainQuery {
    private func checkStatus(_ status: OSStatus) throws {
        if status != errSecSuccess {
            throw KeychainError.init(rawValue: status)
        }
    }
    private func search(with query: Dict) -> OSStatus {
        return SecItemCopyMatching(query.cf, nil)
    }
    private func searchAll<T>(with query: inout Dict) throws -> [T] {
        query[kSecMatchLimit] = kSecMatchLimitAll
        query[kSecReturnAttributes] = true
        return try _search(with: &query)
    }
    private func searchOne<T>(with query: inout Dict) throws -> T {
        query[kSecMatchLimit] = kSecMatchLimitOne
        query[kSecReturnData] = true
        return try _search(with: &query)
    }
    private func _search<T>(with query: inout Dict) throws -> T {
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query.cf, &result)
        try checkStatus(status)
        if let result = result as? T {
            return result
        } else {
            throw KeychainError.badArguments
        }
    }
}
extension KeychainQuery {
    public subscript<T>(dynamicMember keyPath: WritableKeyPath<KeychainQueryInfo, T>) -> T {
        get {
            return self.model[keyPath: keyPath]
        }
        set {
            self.model[keyPath: keyPath] = newValue
        }
    }
}
