//
// Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Sede

struct MemoEditorViewSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore

    func initialize() -> (MemoEditorView.Model, Cmd<MemoEditorView.Msg>) {
        (MemoEditorView.Model(id: memoStore.selectedMemo?.id,
                              content: memoStore.selectedMemo?.content ?? "",
                              memosButtonEnabled: !memoStore.memos.isEmpty),
         .none)
    }

    func receive(model: MemoEditorView.Model, msg: MemoEditorView.Msg) {
        switch msg {
        case .save(let id, let content):
            let memo = Memo(id: id ?? UUID(), content: content)
            memoStore.insert(memo: memo)
            memoStore.selectedMemo = .none
        }
    }
}

struct MemoSelectorSeeder: Seedable {
    @EnvironmentObject var memoStore: MemoStore

    func initialize() -> ([Memo], Cmd<MemoSelectorMsg>) {
        (memoStore.memos, .none)
    }

    func receive(model: [Memo], msg: MemoSelectorMsg) {
        switch msg {
        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
        }
    }
}
