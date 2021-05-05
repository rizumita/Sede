//
//  RepositoryListView.swift
//  SedeSamples
//
//  Created by 和泉田 領一 on 2021/03/28.
//
//

import SwiftUI

struct RepositoryListView: View {
    var repositories: [Repository]
    @Binding var appearedIndex: Int

    var body: some View {
        ForEach(repositories.enumerated().map { $0 }, id: \.element.id) { index, repository in
            NavigationLink(repository.name, destination: Text(repository.name))
                .onAppear { appearedIndex = index }
        }
    }
}

struct RepositoryListView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryListView(repositories: [
            Repository(id: 1, name: "Repo", url: URL(string: "https://example.com")!, description: "desc")
        ], appearedIndex: .constant(0))
    }
}
