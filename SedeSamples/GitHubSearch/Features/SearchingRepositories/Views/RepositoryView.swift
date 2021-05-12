//
//  RepositoryView.swift
//  SedeSamples
//
//  Created by 和泉田 領一 on 2021/05/13.
//
//

import SwiftUI
import Sede

struct RepositoryView: View {
    var repository: Repository

    var body: some View {
        Text(repository.name)
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static var previews: some View {
        RepositoryView(repository: Repository(id: 0,
                                              name: "test",
                                              url: URL(string: "https://example.com")!,
                                              description: .none))
    }
}
