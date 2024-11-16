//
//  ContentView.swift
//  CircularTimer
//
//  Created by HanJW on 11/16/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var timeRemaining: Int = 300
    @State private var progress: CGFloat = 1.0
    @State private var isRunning: Bool = false
    
    private let totalTime: Int = 300
    //    private let progressBarWidth: CGFloat = UIScreen.main.bounds.width - 40
    @State private var timer: AnyCancellable?
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color("gray1"))
                    .frame(width: 273, height: 273)
                
                Circle()
                    .stroke(Color("gray2"), lineWidth: 12)
                    .frame(width: 228, height: 228)
                
                Circle()
                    .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(totalTime))
                    .stroke(Color("blue"), lineWidth: 12)
                    .stroke(Color("blue"), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 228, height: 228)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.1), value: timeRemaining)
                
//                Circle()
//                    .fill(Color("blue"))
//                    .frame(width: 18, height: 18)
//                    .offset(y: -114)
//                    .rotationEffect(.degrees(Double(totalTime - timeRemaining) * Double((360 / totalTime))))
//                    .animation(.easeInOut(duration: 0.1), value: timeRemaining)
                
                VStack{
                    ZStack() {
                        Capsule()
                            .fill(Color("gray2"))
                            .frame(width: 78, height: 24)
                            .padding([.top, .bottom], 4)
                            .padding([.leading, .trailing], 8)
                        
                        Text("GCU • KHU")
                            .font(.system(size: 12))
                            .foregroundStyle(Color("fontBlack"))
                    }
                    
                    VStack(){
                        Text("GDG on Campus")
                            .font(.system(size: 20))
                            .foregroundStyle(Color("fontBlack"))
                        
                        
                        Text("\(formatTime(timeRemaining))")
                            .font(.system(size: 42))
                            .bold()
                            .foregroundStyle(Color("fontBlack"))
                    }
                }
            }
            
            HStack(spacing: 20) {
                Button(action: startCountdown) {
                    Text("Start")
                        .frame(width: 131, height: 43)
                        .background(Color("blue"))
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .cornerRadius(12)
                }
                .disabled(isRunning)
                
                Button(action: resetTimer) {
                    Text("Reset")
                        .frame(width: 131, height: 43)
                        .background(Color("gray3"))
                        .foregroundColor(Color("fontGray"))
                        .font(.system(size: 14))
                        .cornerRadius(12)
                }
                .disabled(!isRunning)
            }
        }
    }
}

private extension ContentView {
    //"MM:SS" 형식으로 format
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startCountdown() {
        timeRemaining = totalTime
        progress = 1.0
        isRunning = true
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                updateCountdown()
            }
    }
    
    private func updateCountdown() {
        if isRunning && timeRemaining > 0 {
            timeRemaining -= 1
            progress = CGFloat(timeRemaining) / CGFloat(totalTime)
        } else if timeRemaining == 0 {
            isRunning = false
        }
    }
    
    private func stopCountdown() {
        timeRemaining = 60 * 5
        progress = 1
        isRunning = false
    }
    
    func resetTimer() {
//        self.timer.upstream.connect().cancel()
        timer?.cancel()
        stopCountdown()
    }
}


#Preview {
    ContentView()
}
