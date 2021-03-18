//
// Created by 和泉田 領一 on 2021/03/17.
//

import Foundation

enum SelectMemoWorkflow {
    typealias ReadMemoStore = () -> MemoStore
    typealias ReadMemoEditor = () -> MemoEditor

    enum Events {
        case success(MemoEditor)
        case failure
    }

    struct Execute {
        var readMemoStore: ReadMemoStore
        var readMemoEditor: ReadMemoEditor

        func callAsFunction(id: UUID) -> Events {
            let result = readMemoStore().memos
                .first { $0.id == id }
                .map(update(memoEditor: readMemoEditor()))
            switch result {
            case let memoEditor?: return .success(memoEditor)
            case .none: return .failure
            }
        }
    }

    static let workflow = Execute.init(readMemoStore:readMemoEditor:)

    static func update(memoEditor: MemoEditor) -> (Memo) -> MemoEditor {
        { memo in
            memoEditor.id = memo.id
            memoEditor.content = memo.content
            memoEditor.content = memo.content   // この行で2度目の代入を行わなければViewが更新されない
            return memoEditor
        }
    }
}
