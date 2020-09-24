//
//  HomeViewController.swift
//  proto-application
//
//  Created by Hessel Bierma on 05/11/2018.
//  Copyright © 2018 S.A. Proto. All rights reserved.
//


import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: News.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \News.publishedAt, ascending: false)]) var news : FetchedResults<News>

    
    @State var showingProfile = false
    
    var body: some View {
        NavigationView {
            List {
//                NavigationLink(
//                    destination: articleDetail(article: news[0])
//                    ){
                    FeaturedArticle(news: news)
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .listRowInsets(EdgeInsets())
//                }
                
                NewsRow()
                .listRowInsets(EdgeInsets())
                
                WidgetsRow()
                .listRowInsets(EdgeInsets())
                
                NavigationLink(destination: profileView()){
                    Text("Scan QR")
                }
            }
            .navigationBarTitle(Text("Featured"))
            .navigationBarItems(trailing: profileButton)
            .sheet(isPresented: $showingProfile) {
                profileView()
            }
        }.onAppear(perform: fetchNews)
    }
    
    
    let url = URL(string: "https://www.proto.utwente.nl/api/news")
    
    func fetchNews() {
        //print("fetching")
        URLSession.shared.newsArticlesTask(with: url!) { newsArticle, response, error in
            if let newsArticle = newsArticle {
                //print(newsArticle.count)
                
                    
                DispatchQueue.main.async{
                    for article in newsArticle {
                        let newArticle = News(context: self.moc)
                        newArticle.id = UUID()
                        newArticle.title = article.title
                        newArticle.publishedAt = article.publishedAt
                        newArticle.content = article.content
                        newArticle.featuredImgUrl = URL(string: article.featuredImageURL ?? "")
                        try? self.moc.save()
                    }
                    self.fetchImgs()
                }

            }else{
                //print("error fetching")
            }
        }.resume()
        
        
    }
    
    func fetchImgs(){
        
        for article in news {
            if article.featuredImgUrl != nil{
                if article.image == nil {
                    URLSession.shared.dataTask(with: article.featuredImgUrl!, completionHandler: { data, response, error in
                        guard let data = data else {
                          print(String(describing: error))
                          return
                        }
                        print("error == nil")
                        DispatchQueue.main.async{
                            article.image = data
                            try? self.moc.save()
                            print("inside dispatchq")
                        }
                    }).resume()
                }
            }
        }
    }
                                                                                                                  
    
//    func delete(at offsets: IndexSet) {
//        for index in offsets {
//            let article = news[index]
//            article.title = "deleted"
//        }
//
//        try? moc.save()
//    }
    
    var profileButton: some View {
        Button(action: { self.showingProfile.toggle()
            self.fetchNews()
        }) {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        }
    }
    
}

struct FeaturedArticle: View {
    var news : FetchedResults<News>
    var body: some View {
        VStack{
            if news.count == 0 {
                Image(uiImage: UIImage(imageLiteralResourceName: "protoLogo") )
                .resizable()
                .scaledToFill()
            }else{
                if news[0].image == nil{
                    Image(uiImage: UIImage(imageLiteralResourceName: "protoLogo") )
                    .resizable()
                    .scaledToFill()
                }else{
                    Image(uiImage: UIImage(data: news[0].image!) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

