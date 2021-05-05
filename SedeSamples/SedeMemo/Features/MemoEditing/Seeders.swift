//
// Created by 和泉田 領一 on 2021/03/10.
//

import SwiftUI
import Sede

struct MemoEditorViewSeeder: Seeder {
    @Environment(\.memoStore) var memoStore

    var observedObjects: [AnyObservableObject] {
        [_memoStore]
    }

    func initialize() -> MemoEditorViewModel {
        MemoEditorViewModel(id: memoStore.selectedMemo?.id,
                            content: memoStore.selectedMemo?.content ?? "",
                            memosButtonEnabled: !memoStore.memos.isEmpty)
    }

    func receive(msg: MemoEditorMsg) {
        switch msg {
        case .save(let id, let content):
            let memo = Memo(id: id ?? UUID(), content: content)
            memoStore.insert(memo: memo)
            memoStore.selectedMemo = .none
        }
    }
}

struct MemoSelectorSeeder: Seeder {
    @Environment(\.memoStore) var memoStore

    func initialize() -> [Memo] {
        memoStore.memos
    }

    func receive(msg: MemoSelectorMsg) {
        switch msg {
        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
        }
    }
}
