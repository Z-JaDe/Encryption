//
//  Key.swift
//  SwiftyRSA
//
//  Created by Loïs Di Qual on 9/19/16.
//  Copyright © 2016 Scoop. All rights reserved.
//

import Foundation

public typealias Padding = SecPadding

public protocol Key {
    var reference: SecKey { get }
    var originalData: Data? { get }

    init(data: Data) throws
    init(reference: SecKey) throws

    init(base64Encoded base64String: String) throws

    init(pemEncoded pemString: String) throws
    init(pemNamed pemName: String, in bundle: Bundle) throws

    init(derNamed derName: String, in bundle: Bundle) throws

    func data() throws -> Data
    func base64String() throws -> String
    func pemString() throws -> String
}

public extension Key {
    func data() throws -> Data {
        return try data(forKeyReference: reference)
    }
    private func data(forKeyReference reference: SecKey) throws -> Data {
        var error: Unmanaged<CFError>?
        let data = SecKeyCopyExternalRepresentation(reference, &error)
        guard let unwrappedData = data as Data? else {
            throw SwiftyRSAError.keyRepresentationFailed(error: error?.takeRetainedValue())
        }
        return unwrappedData
    }
}
public extension Key {
    var blockSize: Int {
        return SecKeyGetBlockSize(reference)
    }
}
public extension Key {
    func base64String() throws -> String {
        return try data().base64EncodedString()
    }
    init(base64Encoded base64String: String) throws {
        guard let data = Data(base64Encoded: base64String, options: [.ignoreUnknownCharacters]) else {
            throw SwiftyRSAError.invalidBase64String
        }
        try self.init(data: data)
    }
}
public extension Key {
    init(pemEncoded pemString: String) throws {
        let base64String = try pemString.pem2base64String()
        try self.init(base64Encoded: base64String)
    }
    init(pemNamed pemName: String, in bundle: Bundle = Bundle.main) throws {
        guard let path = bundle.path(forResource: pemName, ofType: "pem") else {
            throw SwiftyRSAError.pemFileNotFound(name: pemName)
        }
        let keyString = try String(contentsOf: URL(fileURLWithPath: path), encoding: .utf8)
        try self.init(pemEncoded: keyString)
    }
}
public extension Key {
    init(derNamed derName: String, in bundle: Bundle = Bundle.main) throws {
        guard let path = bundle.path(forResource: derName, ofType: "der") else {
            throw SwiftyRSAError.derFileNotFound(name: derName)
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        try self.init(data: data)
    }
}
