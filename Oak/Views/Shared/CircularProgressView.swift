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
                .stroke(remain == 30 ? Color.accentColor : Color.gray, lineWidth: lineWidth)
                .opacity(1)
            // 4.
            Circle()
                .trim(from: number, to: 1)
                .stroke(remain == 30 ? Color.gray : Color.accentColor, lineWidth: lineWidth)
                .rotationEffect(.degrees(-90))
        }.onAppear {
            print("starting at: \(progress), over \(remain) seconds")
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

//var body: some View {
//    ZStack {
//        // 3.
//        Circle()
//            .stroke(remain == 30 ? Color.accentColor : Color.gray, lineWidth: lineWidth)
//            .opacity(1)
//        // 4.
//        Circle()
//            .trim(from: number, to: 1)
//            .stroke(remain == 30 ? Color.gray : Color.accentColor, lineWidth: lineWidth)
//            .rotationEffect(.degrees(-90))
//    }.onAppear {
//        print("starting at: \(progress), over \(remain) seconds")
//        number = progress
//        withAnimation(.linear(duration: remain)) {
//            number = 1
//        }
//    }
//}
