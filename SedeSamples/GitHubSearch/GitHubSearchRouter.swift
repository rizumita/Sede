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
                   label: { Text("Searching user view is not implemented.\nGo to searching repositories view") })

        case .repository(let repository):
            NavigationLink(repository.name, destination: RepositoryView(repository: repository))
        }
    }
}
