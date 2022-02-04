//
//  Player.swift
//  VoiceMemo
//
//  Created by Shivoy Arora on 06/07/21.
//

import SwiftUI

struct Player: View {
    @StateObject var audioPlayer = AudioPlayer()
    @StateObject var memoTimer = MemoTimer()
    @Binding var playerActive: Bool
    
    var body: some View {
        VStack{
            ///Done Button
            HStack{
                Spacer()
                Button("Done"){
                    if audioPlayer.playing {
                        audioPlayer.stopAudio()
                    }
                    playerActive = false
                }
            }
            .padding()
            
            ///Audio Visualizer
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .frame(width:325, height: 270, alignment: .center)
                    .opacity(0)
                AudioVisualizer(soundSamples: $audioPlayer.soundSamples)
                    .frame(width:325, height: 270, alignment: .center)
                
                Image(systemName: audioPlayer.playing ? "speaker.wave.2.fill":"speaker.slash.fill")
            }
            
            ///Progress bar
            ProgressBar(secElapsed: memoTimer.secElapsed, totalTime: memoTimer.totalTime)
            
            ///play/pause and restart button
            HStack{
                Button{
                    ///pause
                    if audioPlayer.playing {
                        audioPlayer.pauseAudio()
                        memoTimer.stopTimer()
                    }
                    ///play
                    else {
                        if audioPlayer.playerTime == 0 {
                            audioPlayer.playAudio()
                            memoTimer.totalTime = Int(audioPlayer.audioPlayer.duration)
                            memoTimer.startTimer()
                        }else {
                            audioPlayer.resumeAudio()
                            memoTimer.startingTime = Int(audioPlayer.playerTime)
                            memoTimer.totalTime = Int(audioPlayer.audioPlayer.duration)
                            memoTimer.startTimer()
                        }
                        audioPlayer.playing = true
                    }
                }label: {
                    Image(systemName: audioPlayer.playing ? "pause.fill":"play.fill")
                }
                
                ///restart button
                Button{
                    if audioPlayer.playing {
                        audioPlayer.stopAudio()
                    }
                    if let _ = memoTimer.timer {
                        memoTimer.stopTimer()
                    }
                    
                    audioPlayer.playAudio()
                    memoTimer.totalTime = Int(audioPlayer.audioPlayer.duration)
                    memoTimer.startTimer()
                }label: {
                    Image(systemName: "backward.end.fill")
                        .padding(.leading)
                }
            }
            .padding()
            .font(.title)
            .foregroundColor(audioPlayer.playing ? .accentColor:.secondary)
            
            Spacer()

        }
        .padding()
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        Player(playerActive: .constant(true))
            .environmentObject(AudioPlayer())
            .preferredColorScheme(.dark)
    }
}
