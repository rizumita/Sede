//
// Created by 和泉田 領一 on 2021/03/23.
//

import SwiftUI
import Sede

struct RepositoriesSearchViewModelReap: Reapable {
    @Environment(\.repositoryStore) var repositoryStore

    var observedObjects: [AnyObservableObject] {
        [_repositoryStore]
    }

    func initialize() -> RepositoriesSearchView.Model {
        RepositoriesSearchView.Model(searchText: repositoryStore.searchText,
                                     repositories: repositoryStore.repositories,
                                     appearedIndex: 0)
    }

    func update(value: RepositoriesSearchView.Model) -> RepositoriesSearchView.Model {
        .init(searchText: value.searchText,
              repositories: repositoryStore.repositories,
              appearedIndex: value.appearedIndex)
    }
}
