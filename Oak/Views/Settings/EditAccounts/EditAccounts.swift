//
//  EditAccounts.swift
//  Oak
//
//  Created by Alex Catchpole on 01/02/2021.
//

import SwiftUI

struct EditAccounts: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: EditAccountsViewModel
    
    @State private var editMode = EditMode.inactive
    
    init(vm: EditAccountsViewModel) {
        self._viewModel = StateObject(wrappedValue: vm)
    }
    
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
            .environment(\.editMode, $editMode)
        }
    }
}
