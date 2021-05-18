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
    @Router<GitHubSearchRoute> var router

    var body: some View {
        switch seed.feature {
        case .searchingRepositories:
            router(.searchingRepositories)
        case .searchingUsers:
            router(.searchingUsers)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
