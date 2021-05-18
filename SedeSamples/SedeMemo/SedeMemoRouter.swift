//
// Created by 和泉田 領一 on 2021/05/18.
//

import SwiftUI
import Sede

enum SedeMemoRoute {
    case editor
    case selector
}

struct SedeMemoRouter: Routable {
    func locate(route: SedeMemoRoute) -> some View {
        switch route {
        case .editor:
            MemoEditorView()
                .seed(MemoEditorViewSeeder())

        case .selector:
            MemoSelectorView()
                .seed(MemoSelectorSeeder())
        }
    }
}
