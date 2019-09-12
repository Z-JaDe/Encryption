//
//  DataWrapper.swift
//  SwiftyRSA
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

public protocol DataWrapper {
    var data: Data { get }
    init(data: Data)
}
// MARK: -
public protocol Base64DataWrapper: DataWrapper {
    var base64String: String { get }
    init(base64Encoded base64String: String) throws
}
public extension Base64DataWrapper {
    var base64String: String {
        return data.base64EncodedString()
    }
    init(base64Encoded base64String: String) throws {
        guard let data = Data(base64Encoded: base64String) else {
            throw SwiftyRSAError.invalidBase64String
        }
        self.init(data: data)
    }
}
// MARK: - 正常的数据可以转换成base64
public protocol NormalDataWrapper: Base64DataWrapper {
    init(string: String, using encoding: String.Encoding) throws
    func string(encoding: String.Encoding) throws -> String
}
public extension NormalDataWrapper {
    init(string: String, using encoding: String.Encoding) throws {
        guard let data = string.data(using: encoding) else {
            throw SwiftyRSAError.stringToDataConversionFailed
        }
        self.init(data: data)
    }
    func string(encoding: String.Encoding) throws -> String {
        guard let str = String(data: data, encoding: encoding) else {
            throw SwiftyRSAError.dataToStringConversionFailed
        }
        return str
    }
}
