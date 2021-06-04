//
// Created by Ryoichi Izumita on 2021/03/10.
//

import SwiftUI
import Combine
import Sede

struct MemoEditorViewSeeder: Seedable {
    @Seeding<MemoEditorView.Model, MemoEditorView.Msg> var seed

    @Environment(\.memoStore) var memoStore
    var observedObjects: some ObservableObject { memoStore }

    func initialize() {
        print(String(describing: Self.self) + "." + #function)
        seed {
            Msg.save(.none, "a")
            Msg.save(.none, "b")
            Msg.save(.none, "c")
        }
        seed.initialize(.init(id: .none, content: "", memosButtonEnabled: false))
    }

    func update() {
        seed(.update)
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
    @Seeding<[Memo], MemoSelectorMsg> var seed

    @Environment(\.memoStore) var memoStore
    var observedObjects: some ObservableObject { memoStore }

    func initialize() {
        seed.initialize(memoStore.memos)
    }

    func update() {
        seed(.update)
    }

    func receive(msg: MemoSelectorMsg) {
        switch msg {
        case .update:
            seed.initialize(memoStore.memos)

        case .select(let id):
            memoStore.selectedMemo = memoStore.memos.first { $0.id == id }
        }
    }
}
