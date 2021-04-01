//
// Created by 和泉田 領一 on 2021/03/23.
//

import SwiftUI
import Sede

let repositoryStoreReap = reaped(\.repositoryStore)

struct RepositoriesSearchViewModelReap: ReapProtocol {
    func initialize(environment: EnvironmentValues) -> RepositoriesSearchView.Model {
        RepositoriesSearchView.Model(searchText: environment.repositoryStore.searchText,
                                     repositories: environment.repositoryStore.repositories,
                                     appearedIndex: 0)
    }
}
