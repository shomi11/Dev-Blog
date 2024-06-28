//
//  File.swift
//  
//
//  Created by MMMBP on 5/19/24.
//

import Foundation
import Ignite

struct Articles: StaticPage {
    
    var title = "Articles"
    
    func body(context: PublishingContext) -> [BlockElement] {
        List {
            Section {
                for item in context.content(ofType: "articles") {
                    ContentPreview(for: item)
                        .width(3)
                        .margin(.bottom)
                }
            }
        }
        .padding(.vertical, 80)
    }
}
