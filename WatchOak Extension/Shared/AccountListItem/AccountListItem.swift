//
//  AccountListItem.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import Foundation
import SwiftUI
import CoreData
import Resolver

struct AccountListItem: View {
    @StateObject var viewModel: AccountListItemViewModel
    
    init(viewModel: AccountListItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack {
                VStack {
                    Text("Google").font(.system(size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("john@doe.co.uk").font(.system(size: 10))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack {
                    HStack {
                        Spacer()
                        Text("30s").font(.system(size: 10))
                        CircularProgressView(lineWidth: 1, progress: 0, remain: 30).frame(width: 15, height: 15, alignment: .center)
                    }.isHidden(viewModel.isHOTP, remove: true)
                    Text("345 212").font(.system(size: 12, design: .monospaced).bold()).frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        })
    }
}

struct AccountListItem_Previews: PreviewProvider {
    static var previews: some View {
        let persistence: PersistentStore = Resolver.resolve()
        let account = Account(context: persistence.viewContext)
        account.issuer = "Google"
        account.name = "alex@alexcatchpoledev.me"
        account.type = .totp
        let vm = AccountListItemViewModel(account: account)
        return AccountListItem(viewModel: vm)
    }
}
