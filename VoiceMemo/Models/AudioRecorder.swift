//
//  AudioRecorder.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 06/07/21.
//

import Foundation
import AVFoundation
import Combine
import SwiftUI

class AudioRecorder: ObservableObject {
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    @Published var recorderTime: TimeInterval = 0
    
    /// for audio visualizer
    private var timer: Timer?
    private var currentSample: Int = 0
    private let numberOfSamples: Int = 20
    @Published var soundSamples = [Float](repeating: .zero, count: 20)
    
    var recordingStarted: Bool = false
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        let recordingSesssion = AVAudioSession.sharedInstance()
        do{
            try recordingSesssion.setCategory(.playAndRecord, mode: .default)
            try recordingSesssion.setActive(true)
        } catch{
            print("Failed to set up recording session")
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
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleLossless),
            AVSampleRateKey: 441000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            
            audioRecorder.isMeteringEnabled = true
            audioRecorder.record(forDuration: 300)
            
            recorderTime = 0
            recording = true
            
            ///audio visualizer start
            timer = Timer.scheduledTimer(withTimeInterval: 0.005, repeats: true, block: { (timer) in
                self.audioRecorder.updateMeters()
                self.soundSamples[self.currentSample] = self.audioRecorder.averagePower(forChannel: 0)
                self.currentSample = (self.currentSample + 1) % self.numberOfSamples
            })
        } catch{
            print("Couldn't start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        
        self.timer?.invalidate()
        self.timer = nil
        
        recording = false
        recorderTime = 0
    }
    
    func pauseRecording() {
        audioRecorder.pause()
        soundSamples = [Float](repeating: .zero, count: numberOfSamples)
        
        self.timer?.invalidate()
        self.timer = nil
        
        recording = false
        recorderTime = audioRecorder.currentTime
    }
}
