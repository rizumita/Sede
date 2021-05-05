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

    func initialize() -> Diad<MemoEditorViewModel, MemoEditorMsg> {
        (MemoEditorViewModel(id: memoStore.selectedMemo?.id,
                             content: memoStore.selectedMemo?.content ?? "",
                             memosButtonEnabled: !memoStore.memos.isEmpty),
         .none)
    }

    func receive(model: MemoEditorViewModel, msg: MemoEditorMsg) {
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

    func initialize() -> Diad<[Memo], MemoSelectorMsg> {
        (memoStore.memos, .none)
    }

    func receive(model: [Memo], msg: MemoSelectorMsg) {
        switch msg {
        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
        }
    }
}
