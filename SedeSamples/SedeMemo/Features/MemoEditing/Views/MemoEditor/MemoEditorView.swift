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
        }.sheet(isPresented: $seeder.showsMemoSelector) {
            router(.selector)
        }.onChange(of: seeder.content) { _ in }
    }

    var navigationBarItemLeading: some View {
        NavigationItemButton(enabled: seeder.memosButtonEnabled,
                             action: { seeder.showsMemoSelector.toggle() },
                             label: { Text("Memos") })
    }

    var navigationBarItemTrailing: some View {
        NavigationItemButton(enabled: seeder.canSave,
                             action: { _seeder(.save(seeder.id, seeder.content)) },
                             label: { Text("Save") })
    }
}

extension MemoEditorView {
    class Model: ObservableObject {
        var id: UUID?
        @Published var content: String
        @Published var memosButtonEnabled: Bool
        var canSave: Bool { !content.isEmpty }
        @Published var showsMemoSelector = false

        init(id: UUID?, content: String, memosButtonEnabled: Bool) {
            self.id = id
            self.content = content
            self.memosButtonEnabled = memosButtonEnabled
        }
    }

    enum Msg {
        case update
        case save(UUID?, String)
    }
}

struct MemoEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MemoEditorView()
            .seed(model: MemoEditorView.Model(id: .none, content: "Preview", memosButtonEnabled: false),
                  receive: { (_: MemoEditorView.Msg) in .none })
    }
}
