//
// Created by 和泉田 領一 on 2021/03/17.
//

import SwiftUI
import Sede

struct MemoSelectorReap: ReapProtocol {
    func reap(msg: MemoSelectorMsg, environment: EnvironmentValues) {
        switch msg {
        case .select(let id):
            _ = SelectMemoWorkflow.workflow({ environment.memoStore }, { environment.memoEditor })(id: id)
        }
    }
}
