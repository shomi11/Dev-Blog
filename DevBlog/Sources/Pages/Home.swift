import Foundation
import Ignite

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
                ContentPreview(for: item)
                    .width(3)
                    .margin(.bottom)
            }
        }
    }
}
