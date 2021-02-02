//
//  EditAccounts.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI
import Resolver

struct EditAccounts: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: EditAccountsViewModel = Resolver.resolve()
    
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(viewModel.accountRowModels) { vm in
                        AccountRow(viewModel: vm)
                    }
                    .onDelete(perform: viewModel.deleteAccount)
                    .deleteDisabled(editMode == .inactive)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Edit Accounts")
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Dismiss")
            }), trailing: EditButton().disabled(viewModel.accountRowModels.isEmpty))
            .onAppear {
                viewModel.fetchAccounts()
            }
            .environment(\.editMode, $editMode)
        }
    }
}
