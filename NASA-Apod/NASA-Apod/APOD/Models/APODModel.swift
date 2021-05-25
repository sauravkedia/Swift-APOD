//
//  APODModel.swift
//  NASA-Apod
//
//  Created by Saurav Kedia on 25/05/21.
//

import Foundation

enum MediaType: String, Codable {
    case Image = "image"
    case Video = "video"
}

class APODModel:NSObject, Codable, NSSecureCoding {
    
    static var supportsSecureCoding: Bool {return true}
    
    var date: String?
    var title: String?
    var explanation: String?
    var url: String?
    var media_type: MediaType?
    var mediaContent:Data?
    
    enum CodingKeys: String, CodingKey {
        case date
        case title
        case explanation
        case url
        case media_type
        case mediaContent
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(date, forKey: CodingKeys.date.rawValue)
        coder.encode(title, forKey: CodingKeys.title.rawValue)
        coder.encode(explanation, forKey: CodingKeys.explanation.rawValue)
        coder.encode(url, forKey: CodingKeys.url.rawValue)
        coder.encode(media_type?.rawValue, forKey: CodingKeys.media_type.rawValue)
        coder.encode(mediaContent, forKey: CodingKeys.mediaContent.rawValue)
    }
    
    required init?(coder: NSCoder) {
        self.date = coder.decodeObject(forKey: CodingKeys.date.rawValue) as? String
        self.title = coder.decodeObject(forKey: CodingKeys.title.rawValue) as? String
        self.explanation = coder.decodeObject(forKey: CodingKeys.explanation.rawValue) as? String
        self.url = coder.decodeObject(forKey: CodingKeys.url.rawValue) as? String
        if let mType = coder.decodeObject(forKey: CodingKeys.media_type.rawValue) as? String{
            self.media_type = MediaType(rawValue: mType)
        }
        self.mediaContent = coder.decodeObject(forKey: CodingKeys.mediaContent.rawValue) as? Data
    }
}
