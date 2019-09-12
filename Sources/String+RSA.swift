//
//  String.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/5/30.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

extension String {
    public func rsaEncryptedStr(_ publicKey: String) -> String? {
        do {
            let clear = try ClearMessage(string: self, using: .utf8)
            let publicKey = try PublicKey(base64Encoded: publicKey)
            return try clear.encrypted(with: publicKey, padding: .PKCS1).base64String
        } catch _ {
            return nil
        }
    }
    public func urlencode(_ charSet: CharacterSet = CharacterSet()) -> String {
        return self.addingPercentEncoding(withAllowedCharacters: charSet) ?? self
    }
    public func urlencodeAllowedLettersAndNumbers() -> String {
        return self.urlencode(CharacterSet.letters.union(.decimalDigits))
    }
    public func urldecode() -> String {
        return self.removingPercentEncoding ?? self
    }
}
