//
//  HomeView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/22/25.
//

import SwiftUI
import MapKit

struct AreaMap: View {
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )
        return Map(coordinateRegion: binding, showsUserLocation: true)
            .ignoresSafeArea()
    }
}


struct HomeView: View {
    @StateObject var runTracker = RunTracker()
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    AreaMap(region: $runTracker.region)
                    
                    Button {
                        runTracker.presentCountdown = true
                    } label: {
                        Text("Start")
                            .bold(true)
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(36)
                            .background(.green)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 40)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle(Text("Runs"))
            .fullScreenCover(isPresented: $runTracker.presentCountdown, content: {
                CountdownView()
                    .environmentObject(runTracker)
            })
            .fullScreenCover(isPresented: $runTracker.presentRunView, content: {
                RunView()
                    .environmentObject(runTracker)
            })
            .fullScreenCover(isPresented: $runTracker.presentPauseView, content: {
                PauseView()
                    .environmentObject(runTracker)
            })
        }
    }
}

#Preview {
    HomeView()
}
