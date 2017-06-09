//
//  HotUrl.swift
//  HotUrls
//
//  Line Stettler & Agovino Marco
//
//  Workshop 6

import Foundation

struct HotUrl {
    
    var name: String
    var url: String
    
    func getPrefixedUrl() -> String {
        
        if url.range(of: "^(http|https)", options: .regularExpression, range: nil, locale: nil) != nil {
            
            return url
        }
        
        return "http://\(url)"
    }
}
