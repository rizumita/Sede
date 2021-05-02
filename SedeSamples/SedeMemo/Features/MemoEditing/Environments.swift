//
// Created by 和泉田 領一 on 2021/03/17.
//

import SwiftUI

struct MemoStoreKey: EnvironmentKey {
    static let defaultValue = MemoStore()
}

extension EnvironmentValues {
    var memoStore: MemoStore {
        get { self[MemoStoreKey.self] }
        set { self[MemoStoreKey.self] = newValue }
    }
}
