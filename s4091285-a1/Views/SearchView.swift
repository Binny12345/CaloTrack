//
//  SearchView.swift
//  s4091285-a1
//
//  Created by Binyam Sisay on 8/8/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var allFoods: [FoodItem] = []
    @State private var showingFoodDetail: Bool = false
    @State private var selectedFood: FoodItem? = nil
    
    // MARK: - Array of Filtered FoodItems
    var filteredFoods: [FoodItem] {
        if searchText.isEmpty {
            return allFoods
        } else {
            return allFoods.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
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
                // TODO: Connect to Manual Log page
            } label: {
                Text("Manual Log")
                Image(systemName: "plus.circle")
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
                    LazyVStack(spacing: 12) {
                        ForEach(filteredFoods) { food in
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
                                Button {
                                    selectedFood = food
                                    showingFoodDetail = true
                                } label: {
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
                    .padding(.horizontal)
                }
            }
            .padding(.top)
            .onAppear {
                allFoods = DataManager.loadFoodData()
            }
        }
        .sheet(isPresented: $showingFoodDetail) {
                FoodDetailView(showingFoodDetail: $showingFoodDetail, foodItem: $selectedFood)
        }
    }
}

#Preview {
    SearchView()
}
