//
//  ActivityItemView.swift
//  Stridr
//
//  Created by Jimmy Chen on 5/27/25.
//

import SwiftUI
import MapKit

struct ActivityItemView: View {
    var run: RunPayload
    var body: some View {
        VStack (spacing: 10) {
            HStack {
                Text(run.createdAt.timeOfDayString())
                    .font(.title)
                    .bold()
                    .padding(.leading, 30)
                    .padding(.top, 20)
                Spacer()
                Text(run.createdAt.formatDate())
                    .font(.headline)
                    .padding(.trailing, 30)
                    .padding(.top, 20)
            }
            
            HStack(spacing: 24) {
                
                Spacer()
                
                VStack() {
                    Text("Distance")
                        .font(.caption)
                    Text("\(run.distance * 3.28084 / 5280, specifier: "%.2f") mi")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
                
                VStack {
                    Text("Pace")
                        .font(.caption)
                    Text("\(run.distance > 0 ? run.pace : 0.0, specifier: "%.2f" ) min/mi")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()

                VStack {
                    Text("Time")
                        .font(.caption)
                    Text("\(run.time.convertDurationToString())")
                        .font(.headline)
                        .bold()
                }
                
                Spacer()
            }
            .padding(.vertical)
            
            Map {
                MapPolyline(coordinates: convertRouteToCoordinates(geoJSON: run.route))
                    .foregroundStyle(.clear)
                    .stroke(.yellow, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    func convertRouteToCoordinates(geoJSON: [GeoJSONCoordinate]) -> [CLLocationCoordinate2D] {
        return geoJSON.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }

}

#Preview {
    ActivityItemView(run: RunPayload(createdAt: .now, userId: .init(), distance: 123123, pace: 12, time: 123, route: []))
}
