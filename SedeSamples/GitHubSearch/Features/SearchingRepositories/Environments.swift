//
// Created by 和泉田 領一 on 2021/03/28.
//

import SwiftUI

struct RepositoryStoreKey: EnvironmentKey {
    static let defaultValue = RepositoryStore()
}

extension EnvironmentValues {
    var repositoryStore: RepositoryStore {
        get { self[RepositoryStoreKey.self] }
        set { self[RepositoryStoreKey.self] = newValue }
    }
}
