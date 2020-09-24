//
//  alfred.swift
//  probeersel
//
//  Created by Hessel Bierma on 20-04-2020.
//  Copyright © 2020 Hessel Bierma. All rights reserved.
//

import SwiftUI

struct alfred: View {
    
    @State private var status : String = "looking"
    
    var body: some View {
        VStack(alignment: .leading) {
            if status == "there" {
                Image("alfredThere")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
            } else if status == "away" {
                Image("alfredAway")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
            } else {
                Image("alfredLooking")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
            }
            
            Text("Alfred")
                .foregroundColor(.primary)
                .font(.caption)
                .frame(width: 155)
        }
        .padding(.leading, 15)
        .onAppear(perform: fetchAlfred)
    }
    
    func fetchAlfred(){
        let url = URL(string: "https://www.proto.utwente.nl/api/isalfredthere")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                if let alfred = try? JSONDecoder().decode(Alfred.self, from: data) {
                    DispatchQueue.main.async {
                        self.status = alfred.status
                    }
                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}


struct alfred_Previews: PreviewProvider {
    static var previews: some View {
        alfred()
    }
}

class Alfred: Codable {
    var status, back: String
    var backunix: Double
}
