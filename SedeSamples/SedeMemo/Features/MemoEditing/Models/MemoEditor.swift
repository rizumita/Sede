//
// Created by 和泉田 領一 on 2021/03/16.
//

import Foundation

class MemoEditor: ObservableObject {
    @Published var id: UUID?
    @Published var content: String

    init(id: UUID? = .none, content: String = "") {
        self.id = id
        self.content = content
    }

    init(memo: Memo) {
        id = memo.id
        content = memo.content
    }
}
