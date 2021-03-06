//
//  GoalDetailsSwiftUIView+Subviews.swift
//  GoalTracker
//
//  Created by Georges on 3/6/21.
//

import Foundation
import SwiftUI

extension GoalDetailsSwiftUIView {
    struct HeaderView: View {
        let text: String
        var body: some View {
            Text(text.uppercased())
                .font(.headline)
                .bold()
                .foregroundColor(.primary)
        }
    }
    struct DetailsRow: View {
        let text: String
        let details: String
        var body: some View {
            HStack {
                Text(text)
                Spacer()
                Divider()
                Spacer()
                Text(details)
                    .foregroundColor(.secondary)
            }
        }
    }
    struct ProgressRow: View {
        let percentage: Double
        var body: some View {
            CircularProgressSwiftUI(
                model: .init(progress: percentage, fontSize: 15)
            )
            .frame(height: 100, alignment: .center)
            .padding()
        }
    }
}
