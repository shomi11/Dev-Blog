import Foundation
import Ignite
import Markdown

@main
struct IgniteWebsite {
    static func main() async {
        let site = DevBlog()
        do {
            try await site.publish()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct DevBlog: Site {
    var name = "MM dev blog"
    var baseTitle = " – MM dev blog"
    var url = URL(string: "https://www.bytework.dev")!//URL("https://www.example.com")
    var builtInIconsEnabled = true
    var syntaxHighlighters = [SyntaxHighlighter.swift]
    var author = "Milos Malovic"
    var homePage = Home()
    var tagPage = Tags()
   
    var layouts: [any ContentPage] {
        Story()
    }
    
    var pages: [any StaticPage] {
        Apps()
        Articles()
    }
    var theme = MyTheme()
}


