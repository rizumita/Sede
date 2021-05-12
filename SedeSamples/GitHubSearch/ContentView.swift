//
//  ContentView.swift
//  GitHubSearch
//
//  Created by Ryoichi Izumita on 2021/03/22.
//

import SwiftUI
import Sede

struct ContentView: View {
    @Seed<AppModel, Never> var seed
    @Route<GitHubSearchRoute> var route

    var body: some View {
        switch seed.feature {
        case .searchingRepositories:
            route(.searchingRepositories)
        case .searchingUsers:
            route(.searchingUsers)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
