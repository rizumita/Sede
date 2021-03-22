//
//  MemoSelectorView.swift
//  SedeMemo
//
//  Created by 和泉田 領一 on 2021/03/17.
//
//

import SwiftUI
import Sede

enum MemoSelectorMsg {
    case select(UUID)
}

struct MemoSelectorView: View {
    @EnvironmentObject var reap: Reap<MemoSelectorMsg>
    @EnvironmentObject var memos: Seed<[Memo]>
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(memos._value, id: \.id) { memo in
            Button(action: {
                reap(.select(memo.id))
                presentationMode.wrappedValue.dismiss()
            },
                   label: { Text(memo.content) })
                .truncationMode(.tail)
        }
    }
}

struct MemoSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoSelectorView()
            .environmentObject(Seed { [Memo(id: UUID(), content: "Preview")] })
            .environmentObject(Reap<MemoSelectorMsg> { msg, _ in print(msg) })
    }
}
