//
//  File.swift
//  
//
//  Created by MMMBP on 5/19/24.
//

import Foundation
import Ignite

struct Apps: StaticPage {

    var title = "My Apps"

    func body(context: PublishingContext) -> [BlockElement] {
        Section {
            Text("I’m Milos, an iOS developer at NCR Corporation for the past six years. I love bringing ideas to life on the screen and making sure everything runs smoothly for users.")
                .font(.title5)
                .fontWeight(.medium)
        }
        .padding(.top, 48)
        Divider()
        Text("My primary work:")
            .font(.title5)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
        List {
            Text("Havana Savannah: Crafted an awesome app for a cozy cafe chain.")
                .font(.title6)
                .fontWeight(.bold)
            Text("Firehouse Subs: Simplified mobile ordering and made the loyalty program a breeze.")
                .font(.title6)
                .fontWeight(.bold)
            Text("Leann Chin: Made food ordering easy and fun.")
                .font(.title6)
                .fontWeight(.bold)
            Text("Internal Apps: Developed apps that help being in our campus more interesting.")
                .font(.title6)
                .fontWeight(.bold)
        }
        Divider()
        Text("My personal work:")
            .font(.title5)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
        Section {
            for item in context.content(ofType: "apps") {
                Card(imageName: "/images/icons/\(item.image ?? "").jpg") {
                    Text(item.title).foregroundStyle(.white).fontWeight(.bold).font(.title2)
                    Text(item.description)
                        .foregroundStyle(.white).opacity(0.8).fontWeight(.semibold)
                    Link("Show more", target: "\(item.path)")
                            .linkStyle(.button)
                }
                .frame(maxWidth: 400)
                .contentPosition(.overlay)
            }
        }
        .padding(.top, 32)
    }
}





