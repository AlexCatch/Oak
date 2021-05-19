//
//  WatchSessionService.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import Foundation
import WatchConnectivity
 
class WatchSessionService: NSObject, WCSessionDelegate {
    static let sharedManager = WatchSessionService()
    
    private override init() {
        super.init()
    }
    
    private let session: WCSession = WCSession.default
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation did complete on watch")
        print(session.receivedApplicationContext)
        print(error)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("did recieve new application context")
    }
}
