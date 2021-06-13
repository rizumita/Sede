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
    @Seeded<Model, Msg> var model
    @Router<SedeMemoRoute> var router

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $model.content)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                    .navigationBarItems(leading: navigationBarItemLeading,
                                        trailing: navigationBarItemTrailing)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationBarTitle("", displayMode: .inline)
            }
        }.sheet(isPresented: $model.showsMemoSelector) {
            router(.selector)
        }
    }

    var navigationBarItemLeading: some View {
        NavigationItemButton(enabled: model.memosButtonEnabled,
                             action: { model.showsMemoSelector.toggle() },
                             label: { Text("Memos") })
    }

    var navigationBarItemTrailing: some View {
        NavigationItemButton(enabled: model.canSave,
                             action: { model(.save(model.id, model.content)) },
                             label: { Text("Save") })
    }
}

extension MemoEditorView {
    struct Model: ObservableValue {
        var id: UUID?
        var content: String
        var memosButtonEnabled: Bool
        var canSave: Bool = false
        var showsMemoSelector = false

        static var published: [PartialKeyPath<Model>] {
            \Model.content
            \Model.canSave
            \Model.memosButtonEnabled
            \Model.showsMemoSelector
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
                  receive: { (_: MemoEditorView.Msg) in })
    }
}
