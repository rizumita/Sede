//
//  MemoEditorView.swift
//  SedeMemo
//
//  Created by Ryoichi Izumita on 2021/03/10.
//
//

import SwiftUI
import Sede

import Combine

struct MemoEditorView: View {
    @Seeder<Model, Msg> var seeder
    @State var showsMemoSelector = false
    @Router<SedeMemoRoute> var router

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $seeder.content)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .navigationBarItems(leading: navigationBarItemLeading,
                                        trailing: navigationBarItemTrailing)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("", displayMode: .inline)
            }
        }.sheet(isPresented: $showsMemoSelector) {
            router(.selector)
        }
    }

    var navigationBarItemLeading: some View {
        NavigationItemButton(enabled: seeder.memosButtonEnabled,
                             action: { showsMemoSelector.toggle() },
                             label: { Text("Memos") })
    }

    var navigationBarItemTrailing: some View {
        NavigationItemButton(enabled: seeder.canSave,
                             action: { _seeder(.save(seeder.id, seeder.content)) },
                             label: { Text("Save") })
    }
}

extension MemoEditorView {
    struct Model {
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

    enum Msg {
        case save(UUID?, String)
    }
}

struct MemoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditorView()
            .seed(initialize: MemoEditorView.Model(id: .none, content: "Preview", memosButtonEnabled: false),
                  receive: { (_, _: MemoEditorView.Msg) in })
    }
}
