//
//  AudioPlayer.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 06/07/21.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioPlayer: ObservableObject {
    let objectWillChange = PassthroughSubject<AudioPlayer, Never>()
    
    var audioPlayer: AVAudioPlayer!
    
    var playerTime: TimeInterval = 0
    
    var playing = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func playAudio() {
        let playSession = AVAudioSession.sharedInstance()
        do{
            try playSession.setCategory(.playback, mode: .default)
            try playSession.setActive(true)
        }catch{
            print("Failed to setup playing session")
        }
        
        var documentsFolder: URL {
            do {
                return try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false)
            } catch {
                fatalError("Can't find documents directory.")
            }
        }
        
        let audioFileName = documentsFolder.appendingPathComponent("RecordedFile.m4a")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFileName)
            audioPlayer.play()
            
            playing = true
            playerTime = 0
            
        }catch {
            print("Couldn't load player ")
        }
    }
    
    func stopAudio() {
        audioPlayer.stop()
        
        playing = false
        playerTime = 0
    }
}
