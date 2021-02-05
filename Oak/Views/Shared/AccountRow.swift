//
//  AccountRow.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

struct AccountRow: View {
    @StateObject var viewModel: AccountRowViewModel
    
    @State private var from: CGFloat = 0
    @State private var code = "43244"
    
    init(viewModel: AccountRowViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.issuer).bold()
                Text(viewModel.username ?? "").font(.subheadline)
            }
            Spacer()
            HStack {
                Text(viewModel.code)
                CircularProgressView(lineWidth: 1, progress: viewModel.progress, remain: viewModel.timeRemaining)
                    .frame(width: 25, height: 25, alignment: .leading).id(viewModel.code)
            }
        }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
    }
}

struct AccountRow_Previews: PreviewProvider {
    static var previews: some View {
        AccountRow(viewModel: AccountRowViewModel(account: Account.Create(issuer: "Amazon", username: "john@doe.co.uk", secret: "demo", algorithm: .sha1, type: .totp, digits: 6, period: 30, counter: 0)))
    }
}
