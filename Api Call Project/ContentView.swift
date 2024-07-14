//
//  ContentView.swift
//  Api Call Project
//
//  Created by Andre Rocha on 14/07/2024.
//

import SwiftUI

struct Advice: Decodable {
    let id: Int
    let advice: String
}

struct AdviceAPIResponse: Decodable {
    let slip: Advice
}

struct ContentView: View {
    @State private var advice: Advice?
    @State private var isShowingConfimCopyAdviceDialog: Bool = false
    @State private var isAboutDialog: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    if let adviceText = advice?.advice {
                        Text(adviceText)
                        Spacer()
                        Button(action: {
                            isShowingConfimCopyAdviceDialog = true
                        }){
                            Image(systemName: "paperclip")
                        }
                        .confirmationDialog("confirmCopyAdvcice", isPresented: $isShowingConfimCopyAdviceDialog){
                            Button("Copy", action: copyAdvice)
                        } message: {
                            Text("You can copy this advice to share with your friends!")
                        }
                    }
                }
                
                Button("Get a advice", action: {
                    Task {
                        await getAdvice()
                    }
                })
                .padding(.top, 10)
                
                Spacer()
                
                Button("About", action: {
                    isAboutDialog = true
                })
                .alert(isPresented: $isAboutDialog){
                    Alert(title: Text("Advices App"), message: Text("Made by ?"))
                }
            }
            .padding()
            .navigationTitle(Text("Advices"))
            
            
        }
    }
    
    func copyAdvice() {
        UIPasteboard.general.string = advice?.advice
    }
    
    func getAdvice() async {
        guard let url = URL(string: "https://api.adviceslip.com/advice") else {
            print("url does not work!")
            return
        }
        
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            //decode data
            if let decodedData = try? JSONDecoder().decode(AdviceAPIResponse.self, from: data) {
                advice = decodedData.slip
            }
        } catch {
            print("Error")
        }
    }
}

#Preview {
    ContentView()
}
