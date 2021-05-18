//
//  GitHubSearchApp.swift
//  GitHubSearch
//
//  Created by Ryoichi Izumita on 2021/03/22.
//

import SwiftUI

@main
struct GitHubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .route(GitHubSearchRouter())
                .seed(AppSeeder())
        }
    }
}
