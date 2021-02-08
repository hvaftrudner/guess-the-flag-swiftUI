//
//  ContentView.swift
//  guessTheFlag
//
//  Created by Kristoffer Eriksson on 2021-01-28.
//

import SwiftUI

//custom flag image view
struct FlagImage : View {
    
    let country: String
    
    var body: some View{
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    //adding animations
    @State private var isEnable = false
    @State private var rotation: Double = 0
    @State private var buttonOpacity: Double = 1
    @State private var scaleNum: CGFloat = 1
    
    var body: some View {
        
        ZStack{
            
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3){ number in
                    Button(action: {
                        withAnimation{
                            self.flagTapped(number)
                            
                            if isEnable{
                                self.rotation += 360
                                self.buttonOpacity = 0.25
                            } else {
                                self.scaleNum = 0.5
                            }
                            
                        }
                        
                        print(type(of: self.countries[number]))
                        
                        
                    }) {
//                        Image(self.countries[number])
//                            .renderingMode(.original)
//                            .clipShape(Capsule())
//                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
//                            .shadow(color: .black, radius: 2)
                        FlagImage(country: self.countries[number])
                            .rotation3DEffect((number == correctAnswer) ? .degrees(rotation) : .degrees(0), axis: (x: 0, y: 0, z: 1))
                            .opacity((number == correctAnswer) ? 1 : buttonOpacity)
                            .scaleEffect(number == correctAnswer ? 1 : scaleNum)
                            
                            
                    }
                }
                Text("Your current score is: \(userScore)")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton:   .default(Text("Continue")) {
                    self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 1
            //added for animation on right flag
            isEnable = true
            
            
        } else {
            scoreTitle = "Wrong thats the flag of \(countries[number])"
            userScore -= 1
            self.scaleNum = 0.5
        }
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        //animation reset
        self.buttonOpacity = 1
        self.scaleNum = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
