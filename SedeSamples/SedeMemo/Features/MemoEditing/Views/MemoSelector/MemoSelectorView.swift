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
    case select(UUID)
}

struct MemoSelectorView: View {
    @Seeder<[Memo], MemoSelectorMsg> var seeder
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(seeder, id: \.id) { memo in
            Button(action: {
                _seeder(.select(memo.id))
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
            .seed(model: [Memo(id: UUID(), content: "Preview")], receive: { (_: MemoSelectorMsg) in .none })
    }
}
