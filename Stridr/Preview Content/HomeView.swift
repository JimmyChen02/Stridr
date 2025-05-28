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
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea(.all, edges: .top)
    }
}

struct HomeView: View {
    let blueGray = Color(red: 0.4, green: 0.55, blue: 0.7)

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
                            .background(blueGray)
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
