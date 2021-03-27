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
    @EnvironmentObject var reap: Reap<MemoEditorMsg>
    @EnvironmentObject var state: Seed<MemoEditorViewState>
    @State var showsMemoSelector = false

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $state.content)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .navigationBarItems(leading: navigationBarItemLeading,
                                        trailing: navigationBarItemTrailing)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("", displayMode: .inline)
            }
        }.sheet(isPresented: $showsMemoSelector) {
            MemoSelectorView().seed(memosSeed).reap(MemoSelectorReap())
        }
    }

    var navigationBarItemLeading: some View {
        NavigationItemButton(enabled: state.storesSomeMemos,
                             action: { showsMemoSelector.toggle() },
                             label: { Text("Memos") })
    }

    var navigationBarItemTrailing: some View {
        NavigationItemButton(enabled: state.canSave,
                             action: { reap(.save(state.id, state.content)) },
                             label: { Text("Save") })
    }
}

struct MemoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditorView()
            .environmentObject(Seed {
                MemoEditorViewState(id: .none,
                                    content: "Preview",
                                    storesSomeMemos: false)
            })
            .environmentObject(Reap<MemoEditorMsg> { msg, _ in print(msg) })
    }
}
