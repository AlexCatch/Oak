//
//  Double+Extensions.swift
//  Oak
//
//  Created by Alex Catchpole on 04/02/2021.
//

import Foundation
import SwiftUI

extension Float
{
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
}

extension CGFloat
{
    func truncate(places : Int)-> CGFloat
    {
        return CGFloat(floor(pow(10.0, CGFloat(places)) * self)/pow(10.0, CGFloat(places)))
    }
}
