//
//  File.swift
//  
//
//  Created by MMMBP on 5/19/24.
//

import Foundation
import Ignite

struct NavBar: Component {
    func body(context: PublishingContext) -> [any PageElement] {
        NavigationBar(
            logo: Image("/images/nav-image.jpeg", description: "nav-image").resizable().lazy().frame(width: "min(60vw, 100px)", height: "100%").cornerRadius(100))
        {
            Link(
                Text("Articles").fontWeight(.bold).foregroundStyle(.dark),
                target: Articles()
            )
            Link(
                Text("My Apps").fontWeight(.bold).foregroundStyle(.dark),
                target: Apps()
            )
        }
        .navigationItemAlignment(.trailing)
        .navigationBarStyle(.dark)
        .background(.lightGray)
        .position(.fixedTop)
    }
}
