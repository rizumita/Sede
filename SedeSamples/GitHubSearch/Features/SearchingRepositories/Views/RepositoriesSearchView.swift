//
//  RepositoriesSearchView.swift
//  GitHubSearch
//
//  Created by Ryoichi Izumita on 2021/03/22.
//

import SwiftUI
import Sede

struct RepositoriesSearchView: View {
    @Seed<Model, Msg> var model

    @State private var selectedID: Int? = nil

    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $model.searchText) {
                    model(.searchFirst)
                }

                RepositoryListView(repositories: model.repositories) { model(.searchNext) }
            }
                .navigationTitle(model.title)
        }
    }
}

extension RepositoriesSearchView {
    enum Msg {
        case update
        case searchFirst
        case searchNext
    }

    struct Model: ObservableValue {
        var searchText: String = ""
        var repositories: [Repository] = []
        var title: String = "Search Repositories"
        var page = 0

        static let published: [PartialKeyPath<Model>] = [\Self.searchText, \Self.repositories, \Self.title]
    }
}

struct RepositoriesSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoriesSearchView()
            .seed(model: RepositoriesSearchView.Model())
    }
}
