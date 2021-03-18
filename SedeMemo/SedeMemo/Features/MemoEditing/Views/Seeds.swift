//
// Created by 和泉田 領一 on 2021/03/10.
//

import SwiftUI
import Sede

let memoEditorSeed = seeded(\.memoEditor)
let memoStoreSeed = seeded(\.memoStore)
let memoEditorViewStateSeed = CombinedSeed(memoEditorSeed, memoStoreSeed) { editor, store, _ -> MemoEditorViewState in
    MemoEditorViewState(id: editor.id,
                        content: editor.content,
                        storesSomeMemos: !store.memos.isEmpty)
}
let memosSeed = memoStoreSeed.map(\.memos)
