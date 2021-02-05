//
//  String+Extensions.swift
//  Oak
//
//  Created by Alex Catchpole on 05/02/2021.
//

import Foundation

extension String {
    func trimmed() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
