//
// Created by 和泉田 領一 on 2021/03/28.
//

import SwiftUI
import Sede

enum MemoEditorSeed {
    static func seed(msg: MemoEditorMsg, environment: EnvironmentValues) {
        switch msg {
        case .save(let id, let content):
            let updateMemoEditor = UpdateMemoEditorWorkflow.workflow(readMemoEditor: { environment.memoEditor })
            _ = SaveMemoWorkflow.workflow(updateMemoEditor, { environment.memoStore })(id: id, content: content)
        }
    }
}

enum MemoSelectorSeed {
    static func seed(msg: MemoSelectorMsg, environment: EnvironmentValues) {
        switch msg {
        case .select(let id):
            _ = SelectMemoWorkflow.workflow({ environment.memoStore }, { environment.memoEditor })(id: id)
        }
    }
}
