//
//  ProgressBar.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 07/07/21.
//

import SwiftUI

struct ProgressBar: View {
    var secElapsed: Int
    var totalTime: Int
    
    var body: some View {
        VStack(alignment: .leading){
            ProgressView(value: Double(secElapsed), total: Double(totalTime))
                .padding([.top, .leading, .trailing])
            
            Text("\(Int(secElapsed/60)) min \(Int(secElapsed%60)) sec of \(totalTime/60) min \(totalTime%60) sec")
                .font(.caption)
                .padding(.leading)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(secElapsed: 60, totalTime: 300)
    }
}
