//
//  AccountsViewModel.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import CodeScanner
import RealmSwift

struct AccountDisplayable: Identifiable {
    var id: String
    var name: String
    var username: String?
}

class AccountsViewModel: ObservableObject {
    enum Sheet: Identifiable {
        case codeScanner
        case settings
        
        var id: Int {
            hashValue
        }
    }
    
    enum ActionSheet: Identifiable {
        case add
        
        var id: Int {
            hashValue
        }
    }
    
    private let otpService: OTPService
    private let accountService: AccountService
    private var realmToken: NotificationToken?
    private var accounts: Results<Account>
    
    @Published var accountRowModels: [AccountRowViewModel] = []
    @Published var scanError: String?
    
    // Navigation flags
    @Published var activeSheet: Sheet?
    @Published var activeActionSheet: ActionSheet?
    
    init(otpService: OTPService, accountService: AccountService) {
        self.otpService = otpService
        self.accountService = accountService
        
        // When our view model is initalised we'll setup our realm observer
        accounts = accountService.fetch()
        initializeRealmObserver()
    }
    
    deinit {
        realmToken?.invalidate()
    }
    
    /// Watch for changes to our accounts
    func initializeRealmObserver() {
        realmToken = accounts.observe { [weak self] (changes: RealmCollectionChange<Results<Account>>) in
            guard let self = self else {
                return
            }
            self.accountRowModels = self.accounts.map { AccountRowViewModel(account: $0) }
        }
    }
    
    func addFromQRCode(data: Result<String, CodeScannerView.ScanError>) {
        activeSheet = .none
        var uri: String?
        do {
            uri = try data.get()
        } catch {
            scanError = "An error occurred while scanning your QR code - please try again"
            return
        }
        
        guard let unwrappedUri = uri else {
            return
        }
        
        do {
            let parsedURI = try otpService.parseSetupURI(uri: unwrappedUri)
            let account = try accountService.save(parsedURI: parsedURI)
            accountRowModels.append(AccountRowViewModel(account: account))
        } catch {
            scanError = "Failed to parse QR code - double check you're scanning a valid code"
        }
    }
}
