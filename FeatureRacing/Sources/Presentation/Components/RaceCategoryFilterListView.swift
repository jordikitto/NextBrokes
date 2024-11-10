//
//  RaceCategoryFilterListView.swift
//  FeatureRacing
//
//  Created by Jordi Kitto on 10/11/2024.
//

import SwiftUI
import FeatureRacingDomain
import CoreDesign

struct RaceCategoryFilterListView: View {
    
    @Binding var selectedCategories: Set<RaceCategory>
    let availableCategories: [RaceCategory]
    
    init(
        selectedCategories: Binding<Set<RaceCategory>>,
        availableCategories: [RaceCategory] = RaceCategory.allCases
    ) {
        self._selectedCategories = selectedCategories
        self.availableCategories = availableCategories
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(availableCategories) { category in
                    Toggle(isOn: isOn(category)) {
                        Label {
                            Text(category.title)
                        } icon: {
                            IconView(icon: category.icon)
                                .foregroundStyle(.black)
                        }
                    }
                }
            } footer: {
                Text("Deselect categories to hide them from the list.")
            }
        }
        .navigationTitle("Filters")
    }
    
    private func isOn(_ category: RaceCategory) -> Binding<Bool> {
        Binding(
            get: { selectedCategories.contains(category) },
            set: { isSelected in
                if isSelected {
                    selectedCategories.insert(category)
                } else {
                    selectedCategories.remove(category)
                }
            }
        )
    }
}

@available(iOS 18.0, *)
#Preview {
    @Previewable @State var categories: Set<RaceCategory> = Set(RaceCategory.allCases)
    
    NavigationStack {
        RaceCategoryFilterListView(selectedCategories: $categories)
    }
}
