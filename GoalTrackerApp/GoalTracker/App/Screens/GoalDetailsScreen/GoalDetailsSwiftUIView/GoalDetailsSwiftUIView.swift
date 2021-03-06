//
//  GoalDetailsSwiftUIView.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import SwiftUI

struct GoalDetailsSwiftUIView: View {
    
    @ObservedObject var viewModel: GoalDetailsSwiftUIViewModel
    
    var body: some View {
        List {
            Section(header: HeaderView(text: "GOAL DETAILS")) {
                Text(viewModel.goalDate)
                Text(viewModel.goalName)
                Text(viewModel.goalDetails)
            }
            Section(header: HeaderView(text: "REWARD")) {
                DetailsRow(
                    text: "Points",
                    details: "\(viewModel.rewardPoints)"
                )
                DetailsRow(
                    text: "Trophy",
                    details: viewModel.rewardTrophy
                )
            }
            Section(header: HeaderView(text: "Progress")) {
                DetailsRow(
                    text: viewModel.criteriaName,
                    details: "\(viewModel.criteriaValue)"
                )
                ProgressRow(percentage: viewModel.percentageComplete)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
}

struct GoalDetailsSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        GoalDetailsSwiftUIView(viewModel: GoalDetailsSwiftUIViewModel())
    }
}
