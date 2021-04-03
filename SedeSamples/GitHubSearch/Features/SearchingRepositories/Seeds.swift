//
// Created by 和泉田 領一 on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

class SearchRepositoriesSeed: Seedable {
    private var cancellables = Set<AnyCancellable>()

    func seed(msg: RepositoriesSearchView.Msg, environment: EnvironmentValues) {
        switch msg {
        case .search(let text):
            cancellables = Set<AnyCancellable>()

            let repositoryStore = environment.repositoryStore
            let workflow = SearchRepositoriesWorkflow.workflow(update: repositoryStore.update)
            workflow(text: text, page: repositoryStore.reachedPage + 1)
                .subscribe(on: DispatchQueue.global())
                .sink { _ in }
                .store(in: &cancellables)

        case .loadIfNeeded(let page):
            ()
        }
    }
}
