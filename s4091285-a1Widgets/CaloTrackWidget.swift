//
//  CaloTrackWidget.swift
//  s4091285-a1Widgets
//
//  Created by Binyam Sisay on 11/10/2025.
//

import WidgetKit
import SwiftUI

/// Acts as the Widget's "App Delegate"
@main
struct CaloTrackWidget: Widget {
    
    let kind: String = "CaloTrackWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CaloTrackWidgetView(entry: entry)
        }
        .configurationDisplayName("CaloTrack Summary")
        .description("Shows your daily calorie and macros progress.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
