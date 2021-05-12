//
// Created by Ryoichi Izumita on 2021/03/28.
//

import SwiftUI

struct RepositoryStoreKey: EnvironmentKey {
    static let defaultValue = RepositoryStore(repositories: [])
}

extension EnvironmentValues {
    var repositoryStore: RepositoryStore {
        get { self[RepositoryStoreKey.self] }
        set { self[RepositoryStoreKey.self] = newValue }
    }
}
