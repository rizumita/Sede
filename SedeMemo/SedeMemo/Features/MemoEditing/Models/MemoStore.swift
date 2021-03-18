//
// Created by 和泉田 領一 on 2021/03/20.
//

import Foundation

class MemoStore:ObservableObject {
    @Published var memos: [Memo] = []
}
