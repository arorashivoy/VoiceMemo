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
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do{
            audioRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            
            audioRecorder.record(forDuration: 300)
            
            recorderTime = 0
            recording = true
        } catch{
            print("Couldn't start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        
        recording = false
        recorderTime = 0
    }
}
