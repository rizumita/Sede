//
// Created by 和泉田 領一 on 2021/03/16.
//

import Foundation

enum SaveMemoWorkflow {
    typealias ReadMemoStore = () -> MemoStore

    enum Events {
        case success(UpdateMemoEditorWorkflow.Events)
    }

    struct Execute {
        var updateMemoEditor: UpdateMemoEditorWorkflow.Execute
        var readMemoStore: ReadMemoStore

        func callAsFunction(id: UUID?, content: String) -> Events {
            insert(id: id, content: content, to: readMemoStore().memos)
            |> update(memoStore: readMemoStore())
            |> { _ in updateMemoEditor(.none, "") }
            |> Events.success
        }
    }

    static let workflow = Execute.init(updateMemoEditor:readMemoStore:)

    static func insert(id: UUID?, content: String, to memos: [Memo]) -> [Memo] {
        let memo = Memo(id: id ?? UUID(), content: content)
        var _memos = memos
        if let index = _memos.firstIndex(where: { $0.id == id }) {
            _memos[index] = memo
        } else {
            _memos.append(memo)
        }
        return _memos
    }

    static func update(memoStore: MemoStore) -> ([Memo]) -> MemoStore {
        { memos in
            memoStore.memos = memos
            return memoStore
        }
    }
}
