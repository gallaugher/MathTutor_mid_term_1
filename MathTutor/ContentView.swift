//
//  ContentView.swift
//  MathTutor
//
//  Created by John Gallaugher on 10/19/26.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var message = ""
    @State private var messageColor: Color = .black
    @State private var audioPlayer: AVAudioPlayer?
    @FocusState private var isFocused: Bool
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            
            VStack {
                Text(firstNumberEmojis)
                
                Text("+")
                
                Text(secondNumberEmojis)
            }
            .font(Font.system(size: 80))
            .minimumScaleFactor(0.5)
            .multilineTextAlignment(.center)
            
            Spacer()
            
            Text("\(firstNumber) + \(secondNumber) =")
                .font(.largeTitle)
            
            TextField("", text: $answer)
                .multilineTextAlignment(.center)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .frame(width: 60)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: isFocused) {
                    if isFocused &&
                        message != "" &&
                        message != "A guess must be a valid number" {
                        resetGame()
                    }
                }

            
            Button("Guess") {
                guard let guessNumber = Int(answer) else {
                    message = "A guess must be a valid number"
                    messageColor = .black
                    return
                }
                isFocused = false
                if guessNumber == firstNumber + secondNumber {
                    playSound(soundName: "correct")
                    message = "Correct! \(firstNumber) + \(secondNumber) = \(firstNumber + secondNumber)"
                    messageColor = .green
                } else {
                    playSound(soundName: "wrong")
                    message = "Sorry, you entered \(answer), but the correct answer is \(firstNumber + secondNumber)"
                    messageColor = .red
                }
                answer = ""
            }
            .buttonStyle(.glassProminent)
            .disabled(answer.isEmpty)
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(messageColor)
                .multilineTextAlignment(.center)
            
            if message != "" && message != "A guess must be a valid number" {
                Button("Try Again?") {
                    resetGame()
                }
            }
            
        }
        .padding()
        .onAppear {
            resetGame()
        }
    }
    
    func setupMathProblem() {
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = ""
        secondNumberEmojis = ""
        let firstEmoji = emojis.randomElement() ?? ""
        let secondEmoji = emojis.randomElement() ?? ""
        for _ in 1...firstNumber {
            firstNumberEmojis += firstEmoji
        }
        for _ in 1...secondNumber {
            secondNumberEmojis += secondEmoji
        }
    }
    
    func playSound(soundName: String) {
        audioPlayer?.stop()
        guard let soundDataAsset = NSDataAsset(name: soundName) else {
            print("😡 ERROR: Could not read file named: \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundDataAsset.data)
            audioPlayer?.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating AVAudioPlayer")
        }
    }
    
    func resetGame() {
        message = ""
        answer = ""
        isFocused = true
        setupMathProblem()
    }
}

#Preview {
    ContentView()
}
