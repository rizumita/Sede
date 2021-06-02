//
// Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Combine
import Sede

struct MemoEditorViewSeeder: Seedable {
    @Seed<MemoEditorView.Model, MemoEditorView.Msg> var seed

    @Environment(\.memoStore) var memoStore
    var observedObjects: some ObservableObject { memoStore }
    var update: Cmd<MemoEditorView.Msg> = .ofMsg(.update)

    func initialize() -> MemoEditorView.Model {
        seed {
            Msg.save(.none, "a")
            Msg.save(.none, "b")
            Msg.save(.none, "c")
        }
        return .init(id: .none, content: "", memosButtonEnabled: false)
    }

    func receive(msg: MemoEditorView.Msg) {
        switch msg {
        case .update:
            seed.id = memoStore.selectedMemo?.id
            seed.content = memoStore.selectedMemo?.content ?? ""
            seed.memosButtonEnabled = !memoStore.memos.isEmpty

        case .save(let id, let content):
            let memo = Memo(id: id ?? UUID(), content: content)
            memoStore.insert(memo: memo)
            memoStore.selectedMemo = .none
        }
    }
}

struct MemoSelectorSeeder: Seedable {
    @Seed<[Memo], MemoSelectorMsg> var seed

    @Environment(\.memoStore) var memoStore
    var observedObjects: some ObservableObject { memoStore }
    var update: Cmd<MemoSelectorMsg> = .ofMsg(.update)

    func initialize() -> [Memo] {
        return memoStore.memos
    }

    func receive(msg: MemoSelectorMsg) {
        switch msg {
        case .update:
            _seed.model = memoStore.memos

        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
        }
    }
}
