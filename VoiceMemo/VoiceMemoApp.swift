//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 06/07/21.
//

import SwiftUI

@main
struct VoiceMemoApp: App {
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var audioPlayer = AudioPlayer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioRecorder)
        }
    }
}
