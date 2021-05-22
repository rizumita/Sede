//
// Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Combine
import Sede

struct MemoEditorViewSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore
    @State var seed = MemoEditorView.Model(id: .none, content: "", memosButtonEnabled: false)

    func initialize() -> Cmd<MemoEditorView.Msg> {
        .batch([Task(memoStore.objectWillChange).attemptToMsg { _ in .memoStoreUpdated },
                .ofMsg(.save(.none, "a")),
                .ofMsg(.save(.none, "b")),
                .ofMsg(.save(.none, "c"))])
    }

    func receive(msg: MemoEditorView.Msg) {
        switch msg {
        case .memoStoreUpdated:
            seed.id = memoStore.selectedMemo?.id
            seed.content = memoStore.selectedMemo?.content ?? ""
            seed.memosButtonEnabled = !memoStore.memos.isEmpty

        case .load:
            seed.id = memoStore.selectedMemo?.id
            seed.content = memoStore.selectedMemo?.content ?? seed.content
            seed.memosButtonEnabled = !memoStore.memos.isEmpty

        case .save(let id, let content):
            let memo = Memo(id: id ?? UUID(), content: content)
            memoStore.insert(memo: memo)
            memoStore.selectedMemo = .none
        }
    }
}

struct MemoSelectorSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore
    @Seed var seed = [Memo]()
    @Seeder<MemoEditorView.Model, MemoEditorView.Msg> var editorSeeder

    func initialize() -> Cmd<MemoSelectorMsg> {
        seed = memoStore.memos
        return .none
    }

    func receive(msg: MemoSelectorMsg) {
        switch msg {
        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
            _editorSeeder(.load)
        }
    }
}
