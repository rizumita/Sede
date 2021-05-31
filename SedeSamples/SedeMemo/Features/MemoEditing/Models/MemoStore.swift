//
// Created by Ryoichi Izumita on 2021/03/20.
//

import Foundation

class MemoStore: ObservableObject {
    @Published var memos: [Memo] = []
    @Published var selectedMemo: Memo?

    func insert(memo: Memo) {
        if let index = memos.firstIndex(where: { $0.id == memo.id }) {
            memos[index] = memo
        } else {
            memos.append(memo)
        }
    }
}
