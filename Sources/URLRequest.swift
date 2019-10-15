//
//  URLRequest.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/8/29.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

extension URLRequest {
    public mutating func setPostParams(params: [String: Any]) {
        self.httpBody = params.paramsStr.data(using: .utf8)
    }
}
