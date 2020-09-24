//
//  NewsRow.swift
//  probeersel
//
//  Created by Hessel Bierma on 20-04-2020.
//  Copyright © 2020 Hessel Bierma. All rights reserved.
//

import SwiftUI

struct NewsRow: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: News.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \News.publishedAt, ascending: false)]) var news : FetchedResults<News>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("News")
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(news, id: \.id) { article in
                        NavigationLink(
                            destination: articleDetail(
                                article: article
                            )
                        ) {
                            NewsItem(article: article)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct NewsItem: View {
    @State var article: News
    var body: some View {
        VStack(alignment: .leading) {
            if article.image == nil {
                Image("protoLogo")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
            } else {
                Image(uiImage: UIImage(data: article.image ?? Data()) ?? UIImage())
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 155, height: 155)
                    .cornerRadius(5)
                    
            }
            Text(article.title!)
                .foregroundColor(.primary)
                .font(.caption)
                .frame(width: 155)
        }
        .padding(.leading, 15)
    }
}

struct NewsRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsRow()
    }
}
