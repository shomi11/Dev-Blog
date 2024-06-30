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
        Card {
            Link(target: "https://x.com/m_11070") {
                Image("/images/social/twitter.png")
                    .resizable()
                    .frame(width: 60)
            }
            .padding(.horizontal)
            Link(target: "https://www.instagram.com/byte_work?igsh=cG1zeHBlOTRydWpz&utm_source=qr") {
                Image("/images/social/instagram.svg")
                    .resizable()
                    .frame(width: 60)
            }
            .padding(.horizontal)
            Link(target: "https://www.linkedin.com/in/milosmalovic/") {
                Image("/images/social/linkedin.webp")
                    .resizable()
                    .frame(width: 60)
            }
            .padding(.horizontal)
        }
        .horizontalAlignment(.center)
        .margin(.top, .extraLarge)
    }
}

