//
//  EquatabalError.swift
//  OakOTP
//
//  Created by Alex on 11/01/2025.
//


struct EquatableError: Error, Equatable, CustomStringConvertible {
    let base: Error
    private let equals: @Sendable (Error) -> Bool

    init<Base: Error>(_ base: Base) {
        self.base = base
        self.equals = { String(reflecting: $0) == String(reflecting: base) }
    }

    init<Base: Error & Equatable>(_ base: Base) {
        self.base = base
        self.equals = { ($0 as? Base) == base }
    }

    static func ==(lhs: EquatableError, rhs: EquatableError) -> Bool {
        lhs.equals(rhs.base)
    }

    var description: String {
        "\(self.base)"
    }

    func asError<Base: Error>(type: Base.Type) -> Base? {
        self.base as? Base
    }

    var localizedDescription: String {
        self.base.localizedDescription
    }
}

extension Error where Self: Equatable {
    func toEquatableError() -> EquatableError {
        EquatableError(self)
    }
}

extension Error {
    func toEquatableError() -> EquatableError {
        EquatableError(self)
    }
}
