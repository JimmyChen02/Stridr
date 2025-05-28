//
//  RunView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/22/25.
//

import SwiftUI
import AudioToolbox

struct RunView: View {
    @EnvironmentObject var runTracker: RunTracker
    let blueGray = Color(red: 0.4, green: 0.55, blue: 0.7)
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("\(runTracker.distance, specifier: "%.2f") m")
                        .font(.title3)
                        .bold()
                    Text("Distance")
                }
                
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("BPM")
                }
                
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(runTracker.pace) min / km")
                        .font(.title3)
                        .bold()
                    Text("Pace")
                }
                
                .frame(maxWidth: .infinity)
            }
            
            VStack {
                
                Text("\(runTracker.elapsedTime.convertDurationToString())")
                    .font(.system(size:64))
                
                Text("Time")
                    .foregroundStyle(.white)
                
            }
            .frame(maxHeight: .infinity)
            
            HStack {
                Button {
                    //no action on tap of stop button
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    withAnimation {
                        runTracker.stopRun()
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {  }
                    }
                }))
                
                Button {
                    runTracker.pauseRun()
                } label: {
                    Image(systemName: "pause.fill" )
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(blueGray)
    }
}

#Preview {
    RunView()
        .environmentObject(RunTracker())
}
