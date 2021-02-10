//
//  TOTPCodeViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 06/02/2021.
//

import Foundation
import SwiftUI
import Resolver

class TOTPCodeViewModel: ObservableObject, CodeViewModel {
    @Injected private var otpService: OTPService
    
    @Published var code: String = ""
    @Published var progress: CGFloat = 0
    @Published var timeRemaining: Double = 0
    
    var account: Account?
    
    private var codeTimer: Timer?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForegroundNotification), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    deinit {
        stop()
    }
    
    func stop() {
        NotificationCenter.default.removeObserver(self)
        codeTimer?.invalidate()
    }
    
    @objc private func applicationWillEnterForegroundNotification() {
        // When we enter the foreground - times might be out of sync, setup our cell
        generateCode()
    }
    
    /// Setup kicks off the code generation and progress circle timer
    func generateCode() {
        codeTimer?.invalidate()
        
        guard let account = account, let code = try? otpService.generateCode(account: account) else {
            self.code = "Error"
            return
        }
        
        self.code = formatCode(code: code)

        let timer = TimeInterval(30)
        let epoch = Date().timeIntervalSince1970

        let from = TimeInterval(UInt64(epoch / timer)) * timer
        let to = Date(timeIntervalSince1970: from + timer)
        
        timeRemaining = round(from + timer - epoch)
        
        let amountThrough = (100 / Float(timer) * Float(timeRemaining) / 100).truncate(places: 2)
        progress = CGFloat((1 - amountThrough)).truncate(places: 2)
        
        codeTimer = Timer.init(fire: to, interval: 0, repeats: false) { [weak self] timer in
            self?.generateCode()
        }
        
        if let timer = codeTimer {
            RunLoop.current.add(timer, forMode: .default)
        }
    }
}

extension Resolver {
    static func RegisterTOTPCodeViewModel() {
        register { TOTPCodeViewModel() }
    }
}
