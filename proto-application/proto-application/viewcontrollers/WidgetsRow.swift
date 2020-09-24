//
//  WidgetsRow.swift
//  probeersel
//
//  Created by Hessel Bierma on 20-04-2020.
//  Copyright © 2020 Hessel Bierma. All rights reserved.
//

import SwiftUI

struct WidgetsRow: View {
    
    //let widgets = [alfred().self]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Widgets")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    alfred()
                    
                    OmNomWidget()
                    
                    alfred()
                }
            }
            .frame(height: 185)
        }
    }
}

struct WidgetsRow_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsRow()
    }
}
