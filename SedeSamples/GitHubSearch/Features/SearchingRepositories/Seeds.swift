//
// Created by 和泉田 領一 on 2021/03/23.
//

import SwiftUI
import Combine
import Sede

struct SearchRepositoriesSeed: Seedable {
    @Environment(\.repositoryStore) var repositoryStore

    @State private var cancellables = Set<AnyCancellable>()

    func seed(msg: RepositoriesSearchView.Msg) {
        switch msg {
        case .search(let text):
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
