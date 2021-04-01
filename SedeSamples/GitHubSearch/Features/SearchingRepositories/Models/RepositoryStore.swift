//
// Created by 和泉田 領一 on 2021/03/28.
//

import Foundation

class RepositoryStore: ObservableObject {
    @Published var searchText: String = ""
    @Published var reachedPage = 0
    @Published var repositories: [Repository] = []

    func update(searchText: String, reachedPag: Int, repositories: [Repository]) {
        if searchText != self.searchText {
            self.repositories = repositories
        } else {
            self.repositories += repositories
        }

        self.searchText = searchText
        self.reachedPage = reachedPag
    }
}
