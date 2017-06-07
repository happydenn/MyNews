//
//  Article.swift
//  MyNewsDemo
//
//  Created by Denny Tsai on 2017/03/26.
//  Copyright © 2017 Denny Tsai. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

let LatestArticlesJSONURL = "https://hpd-iosdev.firebaseio.com/news/latest.json"

class Article: Mappable {
    
    var heading: String?
    var content: String?
    
    var imageURL: URL?
    
    var publishedDate: Date!
    var articleURL: URL!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        heading <- map["heading"]
        content <- map["content"]
        
        let dateTransform = TransformOf<Date, Int>(fromJSON: { millis in
            guard let millis = millis else {
                return nil
            }
            return Date(timeIntervalSince1970: Double(millis) / 1000.0)
        }, toJSON: { date in
            guard let date = date else {
                return nil
            }
            return Int(round(date.timeIntervalSince1970 * 1000))
        })
        
        publishedDate <- (map["publishedDate"], dateTransform)
        
        let urlTransform = TransformOf<URL, String>(fromJSON: { urlString in
            guard let urlString = urlString else {
                return nil
            }
            return URL(string: urlString)
        }, toJSON: { url in
            guard let url = url else {
                return nil
            }
            return url.absoluteString
        })
        
        articleURL <- (map["url"], urlTransform)
        imageURL <- (map["imageUrl"], urlTransform)
    }
    
    class func getLatestArticles(completionHandler: @escaping ([Article]?, Error?) -> Void) {
        let url = URL(string: LatestArticlesJSONURL)!
        
        Alamofire.request(url).responseArray { (response: DataResponse<[Article]>) in
            guard let articles = response.result.value else {
                completionHandler(nil, response.error)
                return
            }
            
            completionHandler(articles, nil)
        }
    }

}
