//
//  AccountRow.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

typealias EditAccountCallback = (_ account: Account) -> Void

struct AccountRow: View {
    @StateObject var viewModel: AccountRowViewModel
    
    let displayCode: Bool
    let editAccountCallback: EditAccountCallback?
    
    init(viewModel: AccountRowViewModel, displayCode: Bool = true, editAccountCallback: EditAccountCallback? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.displayCode = displayCode
        self.editAccountCallback = editAccountCallback
    }
    
    var body: some View {
        Button {
            viewModel.copyCode()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(viewModel.account.issuer ?? "").bold().foregroundColor(.primary)
                    Text(viewModel.account.name ?? "").foregroundColor(.primary).font(.caption)
                }
                Spacer()
                if displayCode {
                    viewModel.codeView().id(UUID().uuidString)
                }
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        } .contextMenu {
            if let callback = editAccountCallback {
                Button {
                    callback(viewModel.account)
                } label: {
                    Label("Edit Account", systemImage: "pencil")
                }
            }
        }
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        return Text("hello")
//        AccountRow(viewModel: AccountRowViewModel(account: Account.Create(issuer: "Amazon", username: "john@doe.co.uk", secret: "demo", algorithm: .sha1, type: .totp, digits: 6, period: 30, counter: 0)), editAccountCallback: {account in })
    }
}
