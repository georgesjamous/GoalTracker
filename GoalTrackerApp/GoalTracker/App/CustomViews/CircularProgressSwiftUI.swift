//
//  CircularProgressSwiftUI.swift
//  GoalTracker
//
//  Created by Georges on 3/4/21.
//

import SwiftUI
import Progress_Bar

// Note:
// quick implementation of a progress view
// i used a library for speed.
struct CircularProgressSwiftUI: View {
    
    struct Model {
        /// Progress between 0 and 1
        let progress: Double
        let fontSize: Int
    }
    
    let model: Model
    
    var fillColor: LinearGradient {
        if progress == 1 {
            return LinearGradient(
                gradient: Gradient(colors: [Color(.systemGreen)]),
                startPoint: .top,
                endPoint: .bottom
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color(.systemBlue)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var progress: Double {
        (0...1).clamp(model.progress)
    }
    
    var body: some View {
        CircularProgress(
            percentage: CGFloat(progress),
            fontSize: CGFloat(model.fontSize),
            backgroundColor: Color(.systemGray6),
            fontColor: .primary,
            borderColor1: Color(.systemGray3),
            borderColor2: fillColor,
            borderWidth: 7
        )
    }
}

struct CircularProgressSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CircularProgressSwiftUI(
                model: .init(progress: 0.5, fontSize: 15)
            )
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
            
            CircularProgressSwiftUI(
                model: .init(progress: 1, fontSize: 15)
            )
            .frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: .center)
        }
    }
}
