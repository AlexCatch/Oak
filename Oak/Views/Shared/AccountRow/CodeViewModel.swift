//
//  CodeView.swift
//  Oak
//
//  Created by Alex Catchpole on 06/02/2021.
//

import Foundation

//SwiftUI has some issues with subclassing observableObjects
protocol CodeViewModel {
    func formatCode(code: String) -> String
}

extension CodeViewModel {
    func formatCode(code: String) -> String {
        switch code.count {
        case 6:
            return code.separate(every: 3)
        default:
            return code.separate(every: 4)
        }
    }
}
