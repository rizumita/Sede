//
// Created by 和泉田 領一 on 2021/03/14.
//

import SwiftUI
import Sede

struct MemoEditorReap: ReapProtocol {
    func reap(msg: MemoEditorMsg, environment: EnvironmentValues) {
        switch msg {
        case .save(let id, let content):
            let updateMemoEditor = UpdateMemoEditorWorkflow.workflow(readMemoEditor: { environment.memoEditor })
            _ = SaveMemoWorkflow.workflow(updateMemoEditor, { environment.memoStore })(id: id, content: content)
        }
    }
}
