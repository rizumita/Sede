//
//  RepositoriesSearchView.swift
//  GitHubSearch
//
//  Created by Ryoichi Izumita on 2021/03/22.
//

import SwiftUI
import Sede

struct RepositoriesSearchView: View {
    @Seeder<Model, Msg> var seeder

    @State private var selectedID: Int? = nil

    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $seeder.searchText) {
                    _seeder(.search)
                }

                RepositoryListView(repositories: seeder.repositories) { _seeder(.search) }
            }
                .navigationTitle(seeder.title)
        }
    }
}

extension RepositoriesSearchView {
    enum Msg {
        case search
    }

    struct Model {
        var searchText: String = ""
        var repositories: [Repository] = []
        var title: String = "Search Repositories"
    }
}

struct RepositoriesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesSearchView()
            .environmentObject(SeederWrapper<RepositoriesSearchView.Model, RepositoriesSearchView.Msg>() { .init() } receive: {
                _, _ in
            })
    }
}
