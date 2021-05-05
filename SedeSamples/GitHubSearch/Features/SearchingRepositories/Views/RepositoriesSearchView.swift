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
                    _seed(.search(seed.searchText))
                }

                RepositoryListView(repositories: seed.repositories, appearedIndex: $seed.appearedIndex)
            }
                    .navigationTitle(seed.title)
        }
    }
}

extension RepositoriesSearchView {
    enum Msg {
        case search(String)
        case loadIfNeeded(Int)
    }

    struct Model {
        var searchText: String = ""
        var repositories: [Repository] = []
        var appearedIndex: Int = 0
        var title: String {
            repositories.isEmpty ? "Search Repositories" : searchText
        }
    }
}

struct RepositoriesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesSearchView()
                .environmentObject(AnySeeder(initialize: RepositoriesSearchView.Model.init) { (msg: RepositoriesSearchView.Msg) in
                })
    }
}
