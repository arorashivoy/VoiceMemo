//
//  Recorder.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 06/07/21.
//

import SwiftUI

struct Recorder: View {
    @StateObject var audioRecorder = AudioRecorder()
    @StateObject var memoTimer = MemoTimer()
    @State private var playerActive: Bool = false
    
    var body: some View {
        VStack{
            
            /// Audio Visualizer
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .frame(width:325, height: 270, alignment: .center)
                    .opacity(0)
                Text("Audio Visiualizer")
                    .padding(.vertical, 125)
                    .padding(.horizontal, 100)
                Image(systemName: audioRecorder.recording ? "mic.fill":"mic.slash")
            }
            
            /// Progress Bar
            ProgressBar(secElapsed: memoTimer.secElapsed, totalTime: memoTimer.totalTime)
            
            ///Play/Pause and stop button
            HStack {
                Button{
                    ///Pause
                    if audioRecorder.recording {
                        audioRecorder.audioRecorder.pause()
                        audioRecorder.recorderTime = audioRecorder.audioRecorder.currentTime
                        audioRecorder.recording = false
                        memoTimer.stopTimer()
                    }
                    ///Play
                    else {
                        if audioRecorder.recorderTime != 0 {
                            audioRecorder.audioRecorder.record()
                            memoTimer.startingTime = Int(audioRecorder.recorderTime)
                            memoTimer.totalTime = 300
                            memoTimer.startTimer()
                            
                        }else {
                            audioRecorder.startRecording()
                            memoTimer.startTimer()
                            
                            audioRecorder.recordingStarted = true
                        }
                        audioRecorder.recording = true
                    }
                }label: {
                    Image(systemName: audioRecorder.recording ? "pause.fill":"play.fill")
                }
                ///Stop
                Button{
                    playerActive = true
                    if audioRecorder.recordingStarted {
                        audioRecorder.stopRecording()
                    }
                    if let _ = memoTimer.timer {
                        memoTimer.stopTimer()
                    }
                    
                }label: {
                    Image(systemName: "stop.fill")
                }
                
            }
            .padding()
            .font(.title)
            .foregroundColor(audioRecorder.recording ? .accentColor:.secondary)
            
            ///Navigating to the player
            Button{
                playerActive.toggle()
                if audioRecorder.recordingStarted {
                    audioRecorder.stopRecording()
                }
            }label: {
                Text("Player")
                    .font(.title2)
                    .padding()
            }
            .sheet(isPresented: $playerActive){
                Player(playerActive: $playerActive)
            }
            
            
            Spacer()
            
            ///Recording  Button
            Button{
                audioRecorder.startRecording()
                audioRecorder.recordingStarted = true
                
                if let _ = memoTimer.timer {
                    memoTimer.stopTimer()
                }
                
                memoTimer.startTimer()
            }label: {
                Image(systemName: (audioRecorder.recording || audioRecorder.recorderTime != 0) ? "circle.dashed.inset.fill":"record.circle")
                    .font(.largeTitle.weight(.heavy))
                    .foregroundColor(.red)
                    .padding()
            }
                
        }
    }
}

struct Recorder_Previews: PreviewProvider {
    static var previews: some View {
        Recorder()
            .environmentObject(AudioRecorder())
            .environmentObject(AudioPlayer())
            .preferredColorScheme(.dark)
    }
}
