//
//  MyGoalsScreenGoalCellSwiftUI.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import SwiftUI
import Progress_Bar

struct MyGoalsScreenGoalCellSwiftUI: View {
    
    let title: String
    let subtitle: String
    
    /// Progress is between 0 and 1
    let progress: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2, content: {
                Text(title.uppercased())
                    .font(.headline)
                    .bold()
                Text(subtitle.uppercased())
                    .font(.subheadline)
            })
            
            Spacer()
            
            CircularProgressSwiftUI(
                model: .init(progress: progress, fontSize: 11)
            )
            // fixed frame for now, we dont need it dynamic
            .frame(width: 80, height: 80, alignment: .center)
            .padding(10)
            
            Image(systemName: "chevron.right.circle.fill")
                .font(.body)
        }
    }
}

struct MyGoalsScreenGoalCellSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        List {
            MyGoalsScreenGoalCellSwiftUI(
                title: "Hello World",
                subtitle: "This is me",
                progress: 0.8
            )
            MyGoalsScreenGoalCellSwiftUI(
                title: "Hello World",
                subtitle: "This is me",
                progress: 2
            )
        }
        
        
    }
}
