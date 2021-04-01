//
// Created by 和泉田 領一 on 2021/03/17.
//

import SwiftUI

struct MemoEditorKey: EnvironmentKey {
    static let defaultValue = MemoEditor()
}

struct MemoStoreKey: EnvironmentKey {
    static let defaultValue = MemoStore()
}

extension EnvironmentValues {
    var memoEditor: MemoEditor {
        get { self[MemoEditorKey.self] }
        set { self[MemoEditorKey.self] = newValue }
    }

    var memoStore: MemoStore {
        get { self[MemoStoreKey.self] }
        set { self[MemoStoreKey.self] = newValue }
    }
}
