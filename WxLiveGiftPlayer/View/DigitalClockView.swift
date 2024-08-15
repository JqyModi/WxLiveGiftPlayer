//
//  DigitalClockView.swift
//  WxLiveGiftPlayer
//
//  Created by Modi on 2024/8/15.
//

import SwiftUI

struct DigitalClockView: View {
    @State private var currentTime: String = Self.getCurrentTime()

    var body: some View {
        Text(currentTime)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .shadow(color: .black, radius: 3, x: 0, y: 0)
            .padding(.leading, 10)
            .padding(.trailing, 10)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .shadow(radius: 3)
            )
            .onAppear(perform: {
                self.startClock()
            })
    }

    private func startClock() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.currentTime = Self.getCurrentTime()
        }
    }

    private static func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
//        formatter.dateFormat = "mm:ss"
        return formatter.string(from: Date())
    }
}
