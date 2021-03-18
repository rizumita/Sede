//
// Created by 和泉田 領一 on 2021/03/17.
//

import Foundation

enum UpdateMemoEditorWorkflow {
    typealias Execute = (UUID?, String) -> Events
    typealias ReadMemoEditor = () -> MemoEditor

    enum Events {
        case success(MemoEditor)
    }

    static func workflow(readMemoEditor: @escaping ReadMemoEditor) -> Execute {
        { id, content in
            updateMemoEditor(readMemoEditor(), id: id, content: content)
            |> Events.success
        }
    }

    static func updateMemoEditor(_ memoEditor: MemoEditor, id: UUID?, content: String) -> MemoEditor {
        memoEditor.id = id
        memoEditor.content = content
        return memoEditor
    }
}
