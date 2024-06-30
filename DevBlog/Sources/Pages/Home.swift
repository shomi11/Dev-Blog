import Foundation
import Ignite
import SwiftUI

struct Home: StaticPage {
 
    var title = "Latest articles"

    func body(context: PublishingContext) -> [BlockElement] {
        Text("latest articles")
            .font(.title1)
            .fontWeight(.bold)
            .foregroundStyle(.secondary)
            .padding(.vertical)
        Section {
            for item in context.content(ofType: "articles").prefix(6) {
                    Card(imageName: item.image) {
                        Text(item.description)
                            .margin(.bottom, .small)
                            .style(
                                "display: -webkit-box",
                                "-webkit-line-clamp: 4",
                                "-webkit-box-orient: vertical",
                                "overflow: hidden"
                            )
                    } header: {
                        Text {
                            Link(item)
                        }
                        .font(.title3)
                    } footer: {
                        let tagLinks = item.tagLinks(in: context)

                        if tagLinks.isEmpty == false {
                            Group {
                                tagLinks
                            }
                            .style("margin-top: -5px")
                        }
                    }
                    .contentPosition(.top)
                
//                ContentPreview(for: item)
//                    .width(3)
//                    .margin(.bottom)
            }
        }
    }
}

