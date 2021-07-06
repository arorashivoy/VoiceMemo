//
//  MemoTimer.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 07/07/21.
//

import Foundation
import Combine
import SwiftUI

class MemoTimer: ObservableObject {
    var timer: Timer?
    var startingTime = 0
    var totalTime = 300
    
    @Published var secElapsed = 0
    
    func startTimer() {
        secElapsed = startingTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if self.secElapsed < self.totalTime {
                self.secElapsed += 1
            }else {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
        
//        secElapsed = 0
//        totalTime = 300
//        startingTime = 0
    }
}
