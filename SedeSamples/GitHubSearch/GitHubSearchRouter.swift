//
// Created by Ryoichi Izumita on 2021/05/13.
//

import SwiftUI
import Sede

struct GitHubSearchRouter: Router {
    @Seed<AppModel, Never> var seed

    func locate(route: GitHubSearchRoute) -> some View {
        switch route {
        case .searchingRepositories:
            RepositoriesSearchView()
                .sede(RepositoriesSearchViewModelSeeder())
                .padding()

        case .searchingUsers:
            Button(action: { seed.feature = .searchingRepositories },
                   label: { Text("Not implemented.\nGo searching repositories view") })
        }
    }
}
