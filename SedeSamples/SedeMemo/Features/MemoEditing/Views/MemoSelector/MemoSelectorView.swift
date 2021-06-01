//
//  MemoSelectorView.swift
//  SedeMemo
//
//  Created by Ryoichi Izumita on 2021/03/17.
//
//

import SwiftUI
import Sede

enum MemoSelectorMsg {
    case update
    case select(UUID)
}

struct MemoSelectorView: View {
    @Seeded<[Memo], MemoSelectorMsg> var seed
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(_seed.model, id: \Memo.id) { memo in
            Button(action: {
                seed(.select(memo.id))
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
            .seed(model: [Memo(id: UUID(), content: "Preview")], receive: { (_: MemoSelectorMsg) in })
    }
}
