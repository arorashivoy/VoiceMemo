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
    
    @Published var playerTime: TimeInterval = 0
    
    /// for audio visualizer
    private var timer: Timer?
    private let numberOfSamples: Int = 20
    @Published var soundSamples = [Float](repeating: .zero, count: 20)
    
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
            audioPlayer.isMeteringEnabled = true
            audioPlayer.play()
            
            playing = true
            playerTime = 0
            
        }catch {
            print("Couldn't load player ")
        }
        
        ///audio visualizer start
        timer = Timer.scheduledTimer(withTimeInterval: 0.09, repeats: true){ [self] timer in
            audioPlayer.updateMeters()
            soundSamples.remove(at: 0)
            soundSamples.append(audioPlayer.averagePower(forChannel: 0))
            
        }
    }
    
    func stopAudio() {
        audioPlayer.stop()
        
        self.timer?.invalidate()
        self.timer = nil
        
        playing = false
        playerTime = 0
    }
    
    func pauseAudio(){
        audioPlayer.pause()
        
//        soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        
        self.timer?.invalidate()
        self.timer = nil
        
        playing = false
        playerTime = audioPlayer.currentTime
    }
}
