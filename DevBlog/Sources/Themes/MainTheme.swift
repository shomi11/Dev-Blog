import Foundation
import Ignite

struct MyTheme: Theme {
    func render(page: Page, context: PublishingContext) -> HTML {
        HTML {
            Head(for: page, in: context)
            Body {
                NavBar()
                
                page.body
                
                MMFooter()
            }
            .padding(.vertical, 120)
        }
    }
}


public struct MMFooter: Component {
    public init() { }

    public func body(context: PublishingContext) -> [any PageElement] {
        Text {
            "Created with"
            Link("Milos", target: URL("https://github.com/twostraws/Ignite"))
        }
        .horizontalAlignment(.center)
        .margin(.top, .extraLarge)
    }
}
