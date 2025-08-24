//
//  ContentView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 7/8/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MainTabView()
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject var weightViewModel = WeightViewModel()
    @StateObject var dailyLogViewModel = DailyLogViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                TabView(selection: $selectedTab) {
                    DashboardView(
                          weightViewModel: weightViewModel,
                          dailyLogViewModel: dailyLogViewModel
                        )
                        .tabItem {
                            Image(systemName: "house")
                            Text("Dashboard")
                        }
                        .tag(0)
                    
                    BarcodeView()
                        .tabItem {
                            Image(systemName: "barcode.viewfinder")
                            Text("Barcode")
                        }
                        .tag(1)
                    
                    SearchView(dailyLogViewModel: dailyLogViewModel)
                        .tabItem {
                            Image(systemName: "plus.circle")
                            .symbolRenderingMode(.palette)
                            .background(.green)
                            .shadow(radius: 5)
                        }
                        .tag(2)
                    
                    WeightInputView(weightViewModel: WeightViewModel())
                        .tabItem {
                            Image(systemName: "plus")
                            Text("Add Weight")
                        }
                        .tag(3)
                    
                    SettingsView(dailyLogViewModel: dailyLogViewModel)
                        .tabItem {
                            Image(systemName: "gear")
                            Text("Settings")
                        }
                        .tag(4)
                    
                }
            }
        }
    }
}

struct appPreviews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
