//
//  MemoEditorView.swift
//  SedeMemo
//
//  Created by 和泉田 領一 on 2021/03/10.
//
//

import SwiftUI
import Sede

import Combine

struct MemoEditorViewModel {
    let id: UUID?
    var content: String
    var memosButtonEnabled: Bool
    var canSave: Bool { !content.isEmpty }

    init(id: UUID?, content: String, memosButtonEnabled: Bool) {
        self.id = id
        self.content = content
        self.memosButtonEnabled = memosButtonEnabled
    }
}

enum MemoEditorMsg {
    case save(UUID?, String)
}

struct MemoEditorView: View {
    @Seed<MemoEditorViewModel, MemoEditorMsg> var seed: MemoEditorViewModel
    @State var showsMemoSelector = false

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $seed.content)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .navigationBarItems(leading: navigationBarItemLeading,
                                        trailing: navigationBarItemTrailing)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("", displayMode: .inline)
            }
        }.sheet(isPresented: $showsMemoSelector) {
            MemoSelectorView().sede(MemoSelectorSeeder())
        }
    }

    var navigationBarItemLeading: some View {
        NavigationItemButton(enabled: seed.memosButtonEnabled,
                             action: { showsMemoSelector.toggle() },
                             label: { Text("Memos") })
    }

    var navigationBarItemTrailing: some View {
        NavigationItemButton(enabled: seed.canSave,
                             action: { _seed(.save(seed.id, seed.content)) },
                             label: { Text("Save") })
    }
}

struct MemoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditorView()
            .environmentObject(AnySeeder {
                MemoEditorViewModel(id: .none, content: "Preview", memosButtonEnabled: false)
            } receive: { (msg: MemoEditorMsg) in })
    }
}
