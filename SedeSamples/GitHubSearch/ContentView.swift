//
//  ContentView.swift
//  GitHubSearch
//
//  Created by 和泉田 領一 on 2021/03/22.
//

import SwiftUI
import Sede

struct ContentView: View {
    var body: some View {
        RepositoriesSearchView()
            .inject(RepositoriesSearchViewModelReap())
            .inject(SearchRepositoriesSeed())
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
