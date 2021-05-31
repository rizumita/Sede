//
// Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Combine
import Sede

struct MemoEditorViewSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore
    @State var seed = MemoEditorView.Model(id: .none, content: "", memosButtonEnabled: false)
    var objectWillChange: some Publisher { memoStore.objectWillChange }
    private(set) var update: Cmd<MemoEditorView.Msg> = .ofMsg(.update)

    func initialize() -> Cmd<MemoEditorView.Msg> {
        .batch([.ofMsg(.save(.none, "a")),
                .ofMsg(.save(.none, "b")),
                .ofMsg(.save(.none, "c"))])
    }

    func receive(msg: MemoEditorView.Msg) -> Cmd<MemoEditorView.Msg> {
        print(msg)
        switch msg {
        case .update:
            seed.id = memoStore.selectedMemo?.id
            seed.content = memoStore.selectedMemo?.content ?? ""
            seed.memosButtonEnabled = !memoStore.memos.isEmpty
            return .none

        case .save(let id, let content):
            let memo = Memo(id: id ?? UUID(), content: content)
            memoStore.insert(memo: memo)
            memoStore.selectedMemo = .none
            return .none
        }
    }
}

struct MemoSelectorSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore
    @State var seed = [Memo]()

    func initialize() -> Cmd<MemoSelectorMsg> {
        .ofMsg(.update)
    }

    func receive(msg: MemoSelectorMsg) -> Cmd<MemoSelectorMsg> {
        switch msg {
        case .update:
            seed = memoStore.memos
            return .none

        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
            return .none
        }
    }
}
