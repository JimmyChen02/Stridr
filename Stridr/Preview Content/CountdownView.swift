//
//  CountdownView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/22/25.
//

import SwiftUI

struct CountdownView: View {
    let blueGray = Color(red: 0.4, green: 0.55, blue: 0.7)

    @EnvironmentObject var runTracker: RunTracker
    @State var timer: Timer?
    @State var countdown = 3
    
    var body: some View {
        Text("\(countdown)")
            .font(.system(size: 256))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(blueGray)
            .foregroundColor(.white)
            .onAppear {
                setupCountdown()
            }
    }
    func setupCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if countdown <= 1 {
                timer?.invalidate()
                timer = nil
                runTracker.presentCountdown = false
                runTracker.startRun()
            } else {
                countdown -= 1
            }
        }
    }
}

#Preview {
    CountdownView()
}
