//
//  AccountRowFeature.swift
//  OakOTP
//
//  Created by Alex on 12/01/2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AccountRowFeature {
    @Dependency(\.haptics) private var haptics: Haptics
    
    @ObservableState
    struct State: Identifiable {
        var account: Account
        var hasCopied: Bool = false
        
        var id: ObjectIdentifier { account.id }
    }
    
    enum Action {
        case copyCode
        case setHasCopied(Bool)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .copyCode:
                return .run { send in
                    await haptics.generate(.success)
                    UIPasteboard.general.string = "oooo"
                    // we'll tell our code view we've copied for 3 seconds before toggling it back
                    await send(.setHasCopied(true))
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    await send(.setHasCopied(false))
                }
            case .setHasCopied(let hasCopied):
                state.hasCopied = hasCopied
                return .none
            }
        }
    }
}

struct AccountRow: View {
    var displayCode: Bool = true
    var store: StoreOf<AccountRowFeature>
//    @StateObject var viewModel: AccountRowViewModel
//
//    let displayCode: Bool
//    let editAccountCallback: EditAccountCallback?
//
//    init(viewModel: AccountRowViewModel, displayCode: Bool = true, editAccountCallback: EditAccountCallback? = nil) {
//        _viewModel = StateObject(wrappedValue: viewModel)
//        self.displayCode = displayCode
//        self.editAccountCallback = editAccountCallback
//    }
    
    var body: some View {
        Button {
            store.send(.copyCode)
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(store.account.issuer ?? "").bold().foregroundColor(.primary)
                    Text(store.account.name ?? "").foregroundColor(.primary).font(.caption)
                }
                Spacer()
                if displayCode {
//                    viewModel.codeView().id(UUID().uuidString)
                }
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
        }
//        .contextMenu {
//            if let callback = editAccountCallback {
//                Button {
//                    callback(viewModel.account)
//                } label: {
//                    Label("Edit Account", systemImage: "pencil")
//                }
//            }
//        }
    }
}
#Preview {
    AccountRow(displayCode: false, store: Store(initialState: AccountRowFeature.State(account: Account.mock), reducer: {
        AccountRowFeature()
    }))
}
