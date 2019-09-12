//
//  Data+Format.swift
//  Encryption
//
//  Created by Apple on 2019/9/12.
//  Copyright © 2019 zjade. All rights reserved.
//

import Foundation

extension Data {
    /// 公钥私钥 格式化
    func format(withPemType pemType: String) -> String {
        let chunks = base64EncodedString().chunk(64)
        let pem = [
            "-----BEGIN \(pemType)-----",
            chunks.joined(separator: "\n"),
            "-----END \(pemType)-----"
        ]
        return pem.joined(separator: "\n")
    }
}
extension String {
    func pem2base64String() throws -> String {
        let lines = self.components(separatedBy: "\n").filter { line in
            return !line.hasPrefix("-----BEGIN") && !line.hasPrefix("-----END")
        }

        guard lines.count != 0 else {
            throw SwiftyRSAError.pemDoesNotContainKey
        }

        return lines.joined(separator: "")
    }
}
