//
//  CircularProgressView.swift
//  Oak
//
//  Created by Alex Catchpole on 31/01/2021.
//

import SwiftUI

struct CircularProgressView: View {
    var lineWidth: CGFloat
    var progress: CGFloat
    var remain: Double
    
    @State private var number: CGFloat = 1
    
    var body: some View {
        ZStack {
            // 3.
            Circle()
                .stroke(Color.accentColor, lineWidth: lineWidth)
                .opacity(1)
            // 4.
            Circle()
                .trim(from: number, to: 1)
                .stroke(Color.gray, lineWidth: lineWidth)
                .rotationEffect(.degrees(-90))
        }.onAppear {
            number = progress
            withAnimation(.linear(duration: remain)) {
                number = 1
            }
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(lineWidth: 2, progress: 0, remain: 30)
    }
}
