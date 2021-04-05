//
//  RepositoriesSearchView.swift
//  GitHubSearch
//
//  Created by 和泉田 領一 on 2021/03/22.
//

import SwiftUI
import Sede

struct RepositoriesSearchView: View {
    @Seed var seed: (Msg) -> ()
    @Reaped var model: Model

    @State private var selectedID: Int? = nil

    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $model.searchText) { seed(.search(model.searchText)) }

                RepositoryListView(repositories: model.repositories, appearedIndex: $model.appearedIndex)
            }
                .navigationTitle(model.title)
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
        var title: String { repositories.isEmpty ? "Search Repositories" : searchText }
    }
}

struct RepositoriesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesSearchView()
            .environmentObject(AnyReaped<RepositoriesSearchView.Model>(initialize: RepositoriesSearchView.Model.init))
            .environmentObject(AnySeed<RepositoriesSearchView.Msg> { print($0) })
    }
}
