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

struct MemoEditorViewState {
    let id: UUID?
    var content: String
    var storesSomeMemos: Bool
    var canSave: Bool { !content.isEmpty }

    init(id: UUID?, content: String, storesSomeMemos: Bool) {
        self.id = id
        self.content = content
        self.storesSomeMemos = storesSomeMemos
    }
}

enum MemoEditorMsg {
    case save(UUID?, String)
}

struct MemoEditorView: View {
    @Seed var reap: (MemoEditorMsg) -> ()
    @Reaped var seed: MemoEditorViewState
    @State var showsMemoSelector = false

    var body: some View {
        print("body")
        return NavigationView {
            VStack {
                TextEditor(text: $seed.content)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .navigationBarItems(leading: navigationBarItemLeading,
                                        trailing: navigationBarItemTrailing)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("", displayMode: .inline)
            }
        }.sheet(isPresented: $showsMemoSelector) {
            MemoSelectorView().reap(memosReap).seed(MemoSelectorSeed.seed)
        }
    }

    var navigationBarItemLeading: some View {
        NavigationItemButton(enabled: seed.storesSomeMemos,
                             action: { showsMemoSelector.toggle() },
                             label: { Text("Memos") })
    }

    var navigationBarItemTrailing: some View {
        NavigationItemButton(enabled: seed.canSave,
                             action: { reap(.save(seed.id, seed.content)) },
                             label: { Text("Save") })
    }
}

struct MemoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditorView()
            .environmentObject(AnyReap {
                MemoEditorViewState(id: .none,
                                    content: "Preview",
                                    storesSomeMemos: false)
            })
            .environmentObject(AnySeed<MemoEditorMsg> { msg, _ in print(msg) })
    }
}
