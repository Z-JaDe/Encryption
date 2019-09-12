//
//  ViewController.swift
//  Encryption
//
//  Created by 郑军铎 on 2018/10/19.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    lazy var publicKey: PublicKey = try! PublicKey(base64Encoded: "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDQZ0YVolLtPXXSowc6CopEXzGI/Tvri6hYT3KZ45G97DQn8ocydBQXSZfRR92MpiZHQn1zydpVBOCj7tUnSh1QoSN9aISG+tuLggYWdav6XlW2JAlduHkMbbyug9aoWIyaZjXXzyV+0e3hjwQhfTeQj9DLuGssWNX3YuYgf/e5LQIDAQAB")
    lazy var privateKey: PrivateKey = try! PrivateKey(pemEncoded: """
-----BEGIN RSA PRIVATE KEY-----
MIICXgIBAAKBgQDQZ0YVolLtPXXSowc6CopEXzGI/Tvri6hYT3KZ45G97DQn8ocy
dBQXSZfRR92MpiZHQn1zydpVBOCj7tUnSh1QoSN9aISG+tuLggYWdav6XlW2JAld
uHkMbbyug9aoWIyaZjXXzyV+0e3hjwQhfTeQj9DLuGssWNX3YuYgf/e5LQIDAQAB
AoGBAKQIpaFhouQY/CRPLeEBatNmGhc5O3Cq/FaGMi3ucUiMIoFO5BtSQn4R7u1L
I5cRMA/mxdfdiXxh2m8uDZhfPbJNZYtA6GLETwKTTkdicdkosBWnkS3jpY9HZd3q
umxh3XYJA2qj3jMrqkxT+rmX2kInb7pz6+R57XKFdvI/xVABAkEA7TgAiZenZOiw
N7GpTQiKFCm7tLb/jzwrabpfsvdWYT0h8XHKDKvzOFxRX5Tku+uiNDUBRJDK/4vy
6OqLVkPQGQJBAODnPIVrG7YZQRNMWn6/F9w66h50PxcJfWDOqykMn/WsafjtZ8Sn
fE4lnOYHoGUWwoSmvUDYCS5SX2FSBA6/RDUCQQC/TOFKFI2+19N8Jn7ki5Vmqz0f
gFBZv2k3K0CPv9zeMAGWh3AsheJvuis5TIalcWHufixWkfnS2ZZ79OGHIMrJAkEA
ug5yYgmm5jHkRRvQbbSW/6l5j3Ip01wVbiXrMU1xc6OME9QLGYRZcKjrMN20UozO
pUDvphpTFhAtOezI0I5o1QJAQr011aer/6XfKDf0sW4fIG1xN2rEgecdVPztKfyh
+d59A/F/pT4b4aEUygXnokhM1knLnY3ijJJYCJH4mvWRhQ==
-----END RSA PRIVATE KEY-----
""")
    override func viewDidLoad() {
        super.viewDidLoad()
        keychainTest()
//        print("aasdasd".md5LowString)
//        print("aasdasd".md5UpperString)
//        print(try! privateKey.pemString())
//        print(try! publicKey.pemString())
//        recordingTime {
//            (0...100).forEach {_ in
//                //            print("  ")
//                encryptedAndDecrypted()
//                //            print("  ")
//                signAndVerify()
//            }
//        }
    }
    func recordingTime(_ function:()->()){
        let start=CACurrentMediaTime()
        function()
        let end=CACurrentMediaTime()
        print("方法耗时为：\(end-start)")
    }
    func keychainTest() {
        do {
            try Keychain.setPassword("123451", service: "com.em", account: "asd")
            try Keychain.setPassword("12345", service: "com.em1", account: "asd")
            let password = try Keychain.password(forService: "com.em", account: "asd")
            let accounts = try Keychain.allAccount()
            let account = try Keychain.accounts(forService: "com.em")
            print(accounts)
            print(account)
            print(password)
        } catch let error {
            print(error)
        }
    }
    func signAndVerify() {
        do {
            let string = String.random(min: 2, max: 1000)
            let clear = try ClearMessage(string: string, using: .utf8)
            let signature = try clear.signed(with: privateKey, digestType: .sha512)
            let base64String = signature.base64String
//            print("sign后的base64: \(base64String)")
            
            do {
                let signature = try Signature(base64Encoded: base64String)
                let result = try clear.verify(with: publicKey, signature: signature, digestType: .sha512)
//                print("verify: \(result)")
                if result == false {
                    fatalError()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func encryptedAndDecrypted() {
        do {
            let string = String.random(min: 2, max: 1000)
//            print("加密: \(string)")
            let clear = try ClearMessage(string: string, using: .utf8)
            let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)
            let base64String = encrypted.base64String
//            print("加密后的base64: \(base64String)")
//            print(try ClearMessage(base64Encoded: base64String).base64String)
            do {
                let encrypted = try EncryptedMessage(base64Encoded: base64String)
                let clear = try encrypted.decrypted(with: privateKey, padding: .PKCS1)

                let _string = try clear.string(encoding: .utf8)
//                print("解密后的字符串: \(_string)")
//                print("解密后的base64: \(clear.base64String)")
                if _string != string {
                    fatalError()
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
extension String {
    public static let uppercaseLetters: String = "ABCDEFGHIGKLMNOPQRSTUVWXYZ"
    public static let lowercaseLetters: String = "abcdefghigklmnopqrstuvwxyz"
    public static let decimalDigits: String = "0123456789"
    
    public static func random(min: Int, max: Int) -> String {
        guard max >= min && min >= 0 else {return ""}
        let count = Int.random(in: min...max)
        return self.random(count: count)
    }
    /// ZJaDe: 随机数字加字母
    public static func random(count: Int) -> String {
        let source = self.uppercaseLetters + self.lowercaseLetters + self.decimalDigits
        return _random(source: source, count: count)
    }
    /// ZJaDe: 随机数字
    public static func randomNumber(count: Int) -> String {
        let source = self.decimalDigits
        return _random(source: source, count: count)
    }
    private static func _random(source: String, count: Int) -> String {
        var result: String = ""
        (0..<count).forEach { (_) in
            result.append(source[Int.random(in: 0..<source.count)])
        }
        return result
    }
    public subscript(integerIndex: Int) -> Character {
        return self[index(startIndex, offsetBy: integerIndex)]
    }
}
