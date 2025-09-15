//
//  SearchView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

/// SearchView for the user to search for their desired FoodItem (Currently hardcoded, will later use API)
struct SearchView: View {
    @State private var searchText = ""
    @State private var allFoods: [FoodSearchResult] = []
    @State private var showingFoodDetail: Bool = false
    @State private var selectedFood: FoodItem? = nil
    @State private var isShowingManualScreen: Bool = false
    @State private var isLoading: Bool = false
    
    @ObservedObject var dailyLogViewModel: DailyLogViewModel
    
    var filteredFoods: [FoodSearchResult] {
        allFoods.filter { food in
            searchText.isEmpty || food.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Search Bar
    var body: some View {
        NavigationStack {
            Text("Search")
                .multilineTextAlignment(.leading)
                .font(.title)
                .bold()
            
            Button {
                isShowingManualScreen.toggle()
            } label: {
                Text("Manual Log")
                Image(systemName: "plus.circle")
            }
            .sheet(isPresented: $isShowingManualScreen) {
                ManualLogView(
                    dailyLogViewModel: dailyLogViewModel
                )
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color(.green))
            .foregroundColor(.white)
            .font(.title3)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search food...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                // MARK: - Recent Searches
                Text("Recent Searches")
                    .font(.headline)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(["Banana", "Oatmeal", "Chicken Breast", "Apple"], id: \.self) { item in
                            Text(item)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(Color(.green))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // MARK: - Search Results
                Text("Results")
                    .font(.headline)
                    .padding(.horizontal)
                ScrollView {
                    if isLoading {
                        ProgressView("Searching...")
                            .padding(.init(top: 150, leading: 150, bottom: 150, trailing: 150))
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredFoods) { food in
                            FoodResultRow(food: food) {
                                selectedFood = FoodItem(
                                    name: food.name,
                                    calories: food.calories,
                                    protein: food.protein,
                                    carbs: food.carbs,
                                    fats: food.fats,
                                    mealType: "Snack",
                                    date: Date()
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
                /// Connects to OFF API and fetches results
                .onChange(of: searchText) { oldValue, newValue in
                    guard !newValue.isEmpty else {
                        allFoods = []
                        return
                    }
                    isLoading = true
                    OpenFoodFactsAPI.shared.searchFoods(query: newValue) { results in
                        DispatchQueue.main.async {
                            self.allFoods = results
                            self.isLoading = false
                        }
                    }
                    
                }
                .padding(.top)
            }
            .sheet(item: $selectedFood) { item in
                FoodDetailView(
                    foodItem: item,
                    dailyLogViewModel: dailyLogViewModel
                )
            }
        }
    }
}

struct FoodResultRow: View {
    let food: FoodSearchResult
    var onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(food.name)
                    .font(.body)
                    .fontWeight(.medium)
                Text("\(Int(food.calories)) kcal • \(Int(food.protein))g Protein")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
