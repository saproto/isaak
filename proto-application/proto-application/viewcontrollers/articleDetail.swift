//
//  articleDetail.swift
//  probeersel
//
//  Created by Hessel Bierma on 20-04-2020.
//  Copyright © 2020 Hessel Bierma. All rights reserved.
//

import SwiftUI

struct articleDetail: View {
    
    var article : News
    
    var body: some View {
        VStack{
            ScrollView{
                FeaturedImg(article: article)
                
//                Text(article.title!)
//                    .font(.largeTitle)
                VStack{
                    HStack{
                        Spacer()
                        
                        Text(date(epoch: article.publishedAt))
                            .font(.caption)
                    }
                    
                    Text(article.content!)

                }
                .padding(.trailing)
                .padding(.leading)
            }
        }
        .navigationBarTitle(article.title!)
        
    }
    
    func date(epoch: Double) -> String {
        let date = NSDate(timeIntervalSince1970: epoch)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date as Date)
    }
    
}

struct FeaturedImg: View {
    
    var article : News
    
    var body: some View {
        Image(uiImage: UIImage(data: article.image ?? Data()) ?? UIImage(imageLiteralResourceName: "protoLogo"))
        .resizable()
        .scaledToFill()
        .frame(height: 200)
        .clipped()
        .listRowInsets(EdgeInsets())
    }
}

//struct articleDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        articleDetail()
//    }
//}
