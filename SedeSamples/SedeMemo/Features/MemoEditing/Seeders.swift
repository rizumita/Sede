//
// Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Combine
import Sede

struct MemoEditorViewSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore
    @Seed var seed = MemoEditorView.Model(id: .none, content: "", memosButtonEnabled: false)

    var objectWillChange: some Publisher {
        seed.objectWillChange
    }

    func receive(msg: MemoEditorView.Msg) {
        switch msg {
        case .load:
            seed.id = memoStore.selectedMemo?.id
            seed.content = memoStore.selectedMemo?.content ?? seed.content
            seed.memosButtonEnabled = !memoStore.memos.isEmpty

        case .save(let id, let content):
            let memo = Memo(id: id ?? UUID(), content: content)
            memoStore.insert(memo: memo)
            memoStore.selectedMemo = .none
            seed.id = .none
            seed.content = ""
            seed.memosButtonEnabled = !memoStore.memos.isEmpty
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
