//
// Created by 和泉田 領一 on 2021/03/10.
//

import SwiftUI
import Sede

let memoEditorReap = reaped(\.memoEditor)
let memoStoreReap = reaped(\.memoStore)
let memoEditorViewStateReap = CombinedReap(memoEditorReap, memoStoreReap,
                                           initialize: { editor, store, _ -> MemoEditorViewState in
                                               MemoEditorViewState(id: editor.id,
                                                                   content: editor.content,
                                                                   storesSomeMemos: !store.memos.isEmpty)
                                           },
                                           update: { _, editor, store, _ in
                                               MemoEditorViewState(id: editor.id,
                                                                   content: editor.content,
                                                                   storesSomeMemos: !store.memos.isEmpty)
                                           })
let memosReap = memoStoreReap.map(\.memos)
