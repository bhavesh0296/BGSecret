//
//  DecryptionHandlerProtocol.swift
//  BGSecret
//
//  Created by bhavesh on 29/08/21.
//  Copyright © 2021 Bhavesh. All rights reserved.
//

import Foundation

public protocol DecryptionHandlerProtocol {

    var next: DecryptionHandlerProtocol? { get }
    func decrypt(data encryptedData: Data) -> String?
}
