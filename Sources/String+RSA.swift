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
        let sign = FSOpenSSL.sign(publicKey, text: self)
        return sign
    }
    public func base64(encodeWithNewlines: Bool = false) -> String? {
        let sign = FSOpenSSL.base64(from: self, encodeWithNewlines: encodeWithNewlines)
        return sign
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
