//
//  PauseView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/22/25.
//

import SwiftUI
import MapKit
import AudioToolbox

struct PauseView: View {
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(runTracker.region), showsUserLocation: true)
                .ignoresSafeArea(edges: .all)
                .frame(height: 300)
//                .onReceive(runTracker.$region) { newRegion in
//                    print("DEBUG: PauseView received region update: \(newRegion.span)")
//                }
            
            HStack{
                VStack{
                    Text("\(runTracker.distance * 3.28084 / 5280, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                    Text("Mi")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("\(runTracker.pace, specifier: "%.2f") min/mi")
                        .font(.title3)
                        .bold()
                    Text("Avg Pace")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("\(runTracker.elapsedTime.convertDurationToString())")
                        .font(.title3)
                        .bold()
                    Text("Time")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            HStack{
                VStack{
                    Text("\(runTracker.calculateCalsBurned(), specifier: "%.0f")")
                        .font(.title3)
                        .bold()
                    Text("Calories")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("0m")
                        .font(.title3)
                        .bold()
                    Text("Elevation")
                }
                .frame(maxWidth: .infinity)
                VStack {
                    Text("DNE")
                        .font(.title3)
                        .bold()
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
            }
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
                   withAnimation {
                       runTracker.resumeRun()
                    }
                } label: {
                    Image(systemName: "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    PauseView()
        .environmentObject(RunTracker())
}
