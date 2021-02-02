//
//  CircularProgressView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

struct CircularProgressView: View {
    var lineWidth: CGFloat
    
    @State private var completionAmount: CGFloat = 0
    
    var body: some View {
        ZStack {
            // 3.
            Circle()
                .stroke(Color.accentColor, lineWidth: lineWidth)
                .opacity(1)
            // 4.
            Circle()
                .trim(from: 0, to: completionAmount)
                .stroke(Color.white, lineWidth: lineWidth)
                .animation(.linear(duration: 30), value: completionAmount)
                .rotationEffect(.degrees(-90))
                 
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(lineWidth: 2)
    }
}
