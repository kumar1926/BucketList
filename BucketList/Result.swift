//
//  Result.swift
//  BucketList
//
//  Created by BizMagnets on 16/07/25.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    var description: String {
        terms?["description"]?.first ?? "No further information"
    }
    static func <(lsh:Page,rhs:Page) ->Bool{
        lsh.title < rhs.title
    }
}
