//
//  AccountsView.swift
//  WatchOak Extension
//
//  Created by Alex Catchpole on 19/05/2021.
//

import SwiftUI
import Resolver

struct AccountsView: View {
    @StateObject private var viewModel: AccountsViewModel = Resolver.resolve()
    
    var body: some View {
        List(viewModel.accountListItemViewModels, id: \.id) { vm in
            AccountListItem(viewModel: vm)
        }.navigationTitle("Accounts")
    }
}

struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsView()
    }
}
