//
//  AccountRowViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import Foundation
import SwiftUI
import Resolver

struct AccountDisplayable: Identifiable {
    var id: String
    var name: String
    var username: String?
}

class AccountRowViewModel: Identifiable, ObservableObject {
    var id: String {
        get {
            return account.id
        }
    }
    
    @Injected private var otpService: OTPService
    
    @Published var code: String = ""
    @Published var issuer: String = ""
    @Published var username: String?
    @Published var progress: CGFloat = 0
    @Published var timeRemaining: Double = 0
    
    let accountDisplayable: AccountDisplayable
    let account: Account
    
    private var setupTimer: Timer?
    
    init(account: Account) {
        self.accountDisplayable = AccountDisplayable(id: account.id, name: account.issuer, username: account.username)
        self.account = account.freeze()
        self._issuer = Published(initialValue: account.issuer)
        self._username = Published(initialValue: account.username)
        setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func applicationWillEnterForegroundNotification() {
        // When we enter the foreground - times might be out of sync, setup our cell
        setup()
    }
    
    /// Setup kicks off the code generation and progress circle timer
    func setup() {
        print("Calculting code")
        setupTimer?.invalidate()
        
        guard let code = try? otpService.generateTOTPCode(account: account) else {
            self.code = "Error"
            return
        }
        
        self.code = code

        let timer = TimeInterval(30)
        let epoch = Date().timeIntervalSince1970

        let from = TimeInterval(UInt64(epoch / timer)) * timer
        let to = Date(timeIntervalSince1970: from + timer)
        
        timeRemaining = round(from + timer - epoch)
        
        let amountThrough = (100 / Float(timer) * Float(timeRemaining) / 100).truncate(places: 2)
        progress = CGFloat((1 - amountThrough)).truncate(places: 2)
        
        print(timeRemaining)
        print(progress)

        setupTimer = Timer.init(fire: to, interval: 0, repeats: false) { timer in
            self.setup()
        }
        
        RunLoop.current.add(setupTimer!, forMode: .default)
    }
}
