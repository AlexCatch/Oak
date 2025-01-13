//
//  ScanQRCodeFeature.swift
//  OakOTP
//
//  Created by Alex on 13/01/2025.
//

import SwiftUI
import ComposableArchitecture
import Dependencies
import CodeScanner

extension ScanResult: @unchecked @retroactive Sendable {}
extension ScanError: Sendable {}
extension ScanQRCodeFeature.Destination.State: Equatable {}

@Reducer
struct ScanQRCodeFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
    }
    
    enum Action {
        case dismissButtonTapped
        case codeScanned(Result<ScanResult, ScanError>)
        
        case errorOccurred(EquatableError)
        
        case destination(PresentationAction<Destination.Action>)
        case delegate(Delegate)
        
        enum ErrorAlert {
            case cancel
        }
        
        enum Delegate {
            case scanCompletion(ParsedURI)
        }
    }
    
    @Reducer
    enum Destination {
        case errorAlert(AlertState<ScanQRCodeFeature.Action.ErrorAlert>)
    }
    
    @Dependency(\.dismiss) var dismiss
    @Dependency(\.otpService) var otpService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .dismissButtonTapped:
                return .run { _ in await dismiss() }
            case .codeScanned(let result):
                return .run { send in
                    do {
                        let code = try result.get().string
                        let parsedURI = try otpService.parseSetupURI(code)
                        await send(.delegate(.scanCompletion(parsedURI)))
                        await dismiss()
                    } catch {
                        await send(.errorOccurred(EquatableError(error)))
                    }
                }
            case .errorOccurred(let error):
                state.destination = .errorAlert(
                    AlertState {
                        TextState("Error")
                    } actions: {
                        ButtonState(role: .cancel) {
                            TextState("Ok")
                        }
                    } message: {
                        TextState("Failed to parse QR Code - please double check code is valid")
                    })
                return .none
            case .destination:
                return .none
            case .delegate:
                return .none
            }
        }
    }
}

struct ScanQRCodeView: View {
    @Bindable var store: StoreOf<ScanQRCodeFeature>
    
    var body: some View {
        NavigationView {
            CodeScannerView(
                codeTypes: [.qr],
                scanMode: .oncePerCode,
                showViewfinder: true,
                completion: { store.send(.codeScanned($0)) })
            .navigationBarItems(leading: Button("Dismiss") { store.send(.dismissButtonTapped) })
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .alert($store.scope(state: \.destination?.errorAlert, action: \.destination.errorAlert))
        }
    }
}
