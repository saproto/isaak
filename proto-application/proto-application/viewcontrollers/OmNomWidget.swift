//
//  OmNomWidget.swift
//  probeersel
//
//  Created by Hessel Bierma on 20-04-2020.
//  Copyright © 2020 Hessel Bierma. All rights reserved.
//

import SwiftUI

struct OmNomWidget: View {
    var body: some View {
        VStack(alignment: .leading){
            ZStack(alignment: .top){
                
                Image("background")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
                
                VStack{
                    Spacer()
                    
                    Text("Total this month:")
                        .foregroundColor(Color.white)
                        .font(.caption)
                    //.frame(width: 155)

                    Text("€12.34")
                        .foregroundColor(Color.white)

                    Spacer()

                    Text("Next Withdrawal:")
                        .foregroundColor(Color.white)
                        .font(.caption)
                    //.frame(width: 155)

                    Text("€11.22")
                        .foregroundColor(Color.white)
                    
                    Spacer()

                }.frame(width: 155, height: 155)
            }

            
            Text("OmNomCom")
            .foregroundColor(.primary)
            .font(.caption)
            .frame(width: 155)
        }
        .padding(.leading, 15)
    }
}

struct OmNomWidget_Previews: PreviewProvider {
    static var previews: some View {
        OmNomWidget()
    }
}
