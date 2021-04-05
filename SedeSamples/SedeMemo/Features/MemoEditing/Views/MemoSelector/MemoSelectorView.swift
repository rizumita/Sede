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
    @Seed var reap: (MemoSelectorMsg) -> ()
    @Reaped var memos: [Memo]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(memos, id: \.id) { memo in
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
            .environmentObject(AnyReaped { [Memo(id: UUID(), content: "Preview")] })
            .environmentObject(AnySeed<MemoSelectorMsg> { msg, _ in print(msg) })
    }
}
