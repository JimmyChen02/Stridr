//
//  ActivityView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import SwiftUI

struct ActivityView: View {
    @State var activities = [RunPayload]()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { run in
                    NavigationLink {
                        ActivityItemView(run: run)
                    } label: {
                        VStack (alignment: .leading) {
                            Text(run.createdAt.timeOfDayString())
                                .font(.title2)
                                .bold()
                            
                            Text(run.createdAt.formatDate())
                                .font(.caption)
                            HStack(spacing: 24) {
                                VStack {
                                    Text("Distance")
                                        .font(.caption)
                                    Text("\(run.distance * 3.28084 / 5280, specifier: "%.2f") mi")
                                        .font(.headline)
                                        .bold()
                                }
                                VStack {
                                    Text("Pace")
                                        .font(.caption)
                                    Text("\(run.distance > 0 ? run.pace : 0.0, specifier: "%.2f" ) min")
                                        .font(.headline)
                                        .bold()
                                }

                                VStack {
                                    Text("Time")
                                        .font(.caption)
                                    Text("\(run.time.convertDurationToString())")
                                        .font(.headline)
                                        .bold()
                                }
                            }
                            .padding(.vertical)
                        }
                        .frame(maxWidth:.infinity, alignment: .leading)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(role: .destructive) {
                        Task {
                            do {
                                try await AuthService.shared.logout()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("Logout")
                            .foregroundStyle(.red)
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        guard let userId = AuthService.shared.currentSession?.user.id else { return }
                        activities = try await DatabaseService.shared.fetchWorkouts(for: userId)
                        activities.sort(by: {$0.createdAt >= $1.createdAt })
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityView()
}
