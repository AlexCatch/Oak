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
    
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func setApplicationContext(context: [String : Any]) throws {
        guard let session = validSession else {
            return
        }
        
        try session.updateApplicationContext(context)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activation did complete")
        print(activationState.rawValue)
        print(error)
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
    }
}
