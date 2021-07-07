//
//  AudioVisualizer.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 07/07/21.
//

import SwiftUI

let numberOfSamples: Int = 20

struct BarView: View {
    var value: CGFloat
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .top, endPoint: .bottom))
                    .frame(height: value)
            }
        }
    }
}

struct AudioVisualizer: View {
    @Binding var soundSamples: [Float]
    
    func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 25) / 2

        return CGFloat(level * (270/25))
    }
    
    var body: some View {
        VStack(alignment: .center){
            HStack(spacing: 4){
                ForEach(soundSamples, id: \.self) {level in
                    BarView(value: self.normalizeSoundLevel(level: level))
                        .transition(.identity)
                    
                }
            }
        }
    }
}

struct AudioVisualizer_Previews: PreviewProvider {
    static var previews: some View {
        AudioVisualizer(soundSamples: .constant([Float](repeating: .zero, count: 20)))
            .environmentObject(AudioRecorder())
    }
}
