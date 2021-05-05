//
//  RepositoriesSearchView.swift
//  GitHubSearch
//
//  Created by 和泉田 領一 on 2021/03/22.
//

import SwiftUI
import Sede

struct RepositoriesSearchView: View {
    @Seed<Model, Msg> var seed

    @State private var selectedID: Int? = nil

    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $seed.searchText) {
                    _seed(.search)
                }

                RepositoryListView(repositories: seed.repositories) { _seed(.search) }
            }
                .navigationTitle(seed.title)
        }
    }
}

extension RepositoriesSearchView {
    enum Msg {
        case search
    }

    struct Model {
        var searchText:    String       = ""
        var repositories:  [Repository] = []
        var title:         String = "Search Repositories"
    }
}

struct RepositoriesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesSearchView()
            .environmentObject(AnySeeder<RepositoriesSearchView.Model, RepositoriesSearchView.Msg>() { .init() } receive: {
                _, _ in
            })
    }
}
