//
//  AccountRow.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

struct AccountRow: View {
    @StateObject var viewModel: AccountRowViewModel
    
    init(viewModel: AccountRowViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.accountDisplayable.name).bold()
                Text(viewModel.accountDisplayable.username ?? "").font(.subheadline)
            }
            Spacer()
            TOTPCodeView(viewModel: TOTPCodeViewModel(account: viewModel.account))
        }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(viewModel: AccountRowViewModel(account: Account.Create(issuer: "Amazon", username: "john@doe.co.uk", secret: "demo", algorithm: .sha1, type: .totp, digits: 6, period: 30, counter: 0)))
    }
}
