//
//  ContentView.swift
//  SedeMemo
//
//  Created by 和泉田 領一 on 2021/03/10.
//

import SwiftUI
import Sede

struct ContentView: View {
    var body: some View {
        MemoEditorView()
            .sede(MemoEditorViewSeeder())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
