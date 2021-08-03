//
//  Data+Extensions.swift
//  OakOTP
//
//  Created by Alex Catchpole on 03/08/2021.
//

import Foundation

extension Data {
    func extract(from data: inout Data, length: Int) -> Data? {
        guard data.count > 0 else {
            return nil
        }

        // Create a range based on the length of data to return
        let range = 0..<length

        // Get a new copy of data
        let subData = data.subdata(in: range)

        // Mutate data
        data.removeSubrange(range)

        // Return the new copy of data
        return subData
    }
}
