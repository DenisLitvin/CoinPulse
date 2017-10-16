//
//  NewsManager.swift
//  CoinPulse
//
//  Created by macbook on 18.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import Foundation
import Kanna

extension ApiManager{
    
    static let news: NewsManager = {
        let news = NewsManager()
        return news
    }()
    
}

class NewsManager {
    
    func fetchNews(complition: @escaping([NewsItem]) -> () ){
        let url = URL(string: "https://cryptovest.com/feed/")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print(error)
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode.isSuccessHttpCode, let data = data{
                let xml = XML(xml: data, encoding: .utf8)
                var newsItems: [NewsItem] = []
                for item in (xml?.css("item"))!{
                    guard let titleNode = item.at_css("title"),
                        let title = titleNode.text,
                        let dateNode = item.at_css("pubDate"),
                        let dateString = dateNode.text,
                        let linkNode = item.at_css("link"),
                        let link = linkNode.text else { return }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    
                    dateFormatter.dateFormat = "E, d MMM y HH:mm:ss Z"
                    let date = dateFormatter.date(from: dateString)
                    let newTitle = title.replacingOccurrences(of: "&quot;", with: "\"")
                    newsItems.append(NewsItem(title: newTitle, date: date!, urlString: link))
                }
                DispatchQueue.main.async {
                    complition(newsItems)
                }
            }
            }.resume()
    }
}







