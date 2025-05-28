//
//  StridrTabView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/22/25.
//

import SwiftUI

struct StridrTabView: View {
    @State var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "figure.run")
                    
                    Text("Run")
                }
            ActivityView()
                .tag(1)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    
                    Text("Activity")
                }
        }
    }
}

#Preview {
    StridrTabView()
}
