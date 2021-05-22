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
                    _seeder(.searchFirst)
                }

                RepositoryListView(repositories: seeder.repositories) { _seeder(.searchNext) }
            }
                .navigationTitle(seeder.title)
        }
    }
}

extension RepositoriesSearchView {
    enum Msg {
        case searchFirst
        case searchNext
    }

    class Model: ObservableObject {
        @Published var searchText: String = ""
        @Published var repositories: [Repository] = []
        @Published var title: String = "Search Repositories"
        var page = 0
    }
}

struct RepositoriesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesSearchView()
            .seed(model: RepositoriesSearchView.Model()) { (_: RepositoriesSearchView.Msg) in }
    }
}
