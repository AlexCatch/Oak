//
//  SiriService.swift
//  OakOTP
//
//  Created by Alex Catchpole on 10/09/2021.
//

import Foundation
import Intents
import Resolver

protocol SiriService {
    var hasPermission: Bool { get }
    func requestPermission(result: @escaping (Bool) -> Void)
}

class RealSiriService: SiriService {
    var hasPermission: Bool {
        return INPreferences.siriAuthorizationStatus() == .authorized
    }
    
    func requestPermission(result: @escaping (Bool) -> Void) {
        INPreferences.requestSiriAuthorization { status in
            result(status == .authorized)
        }
    }
}

extension Resolver {
    public static func RegisterSiriService() {
        register { RealSiriService() as SiriService }
    }
}

