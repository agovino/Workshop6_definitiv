//
//  ArrayResource.swift
//  HotUrls
//
//  Line Stettler & Agovino Marco
//
//  Workshop 6

import Foundation

struct ArrayResource: UrlResource {
    
    func getList() -> [HotUrl] {
        var hotUrls = [HotUrl]()

        hotUrls.append(HotUrl(name: "News", url: "http://zeit.de/news"))
        hotUrls.append(HotUrl(name: "Suchmaschine", url: "http://google.de"))
        
        return hotUrls
    }
}
