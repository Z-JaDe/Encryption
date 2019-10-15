//
//  Keychain.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

public struct Keychain {
    public enum Key {
        public static let accountKey = "acct"
        public static let createdAtKey = "cdat"
        public static let classKey = "labl"
        public static let descriptionKey = "desc"
        public static let labelKey = "labl"
        public static let lastModifiedKey = "mdat"
        public static let whereKey = "svce"
    }
    ///在什么条件下可以获取到里面的内容
    public static var accessibilityType: CFString?// = kSecAttrAccessibleWhenUnlocked
}
extension Keychain {
    public static func password(forService service: String, account: String) throws -> String {
        var query = KeychainQuery(service: service, account: account)
        try query.fetch()
        return query.password
    }
    public static func passwordData(forService service: String, account: String) throws -> Data {
        var query = KeychainQuery(service: service, account: account)
        try query.fetch()
        return query.passwordData
    }
}
extension Keychain {
    public static func deletePassword(forService service: String, account: String) throws {
        let query = KeychainQuery(service: service, account: account)
        try query.deleteItem()
    }
}
extension Keychain {
    public static func setPassword(_ password: String, service: String, account: String) throws {
        var query = KeychainQuery(service: service, account: account)
        query.password = password
        try query.save()
    }
    public static func setPasswordData(_ passwordData: Data, service: String, account: String) throws {
        var query = KeychainQuery(service: service, account: account)
        query.passwordData = passwordData
        try query.save()
    }
}
extension Keychain {
    public static func allAccount() throws -> [[String: Any]] {
        return try accounts(forService: "")
    }
    public static func accounts(forService service: String) throws -> [[String: Any]] {
        let query = KeychainQuery(service: service, account: "")
        return try query.fetchAll()
    }
}
