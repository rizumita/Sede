//
// Created by Ryoichi Izumita on 2021/05/13.
//

import Foundation
import Sede
import Combine

class AppModel: ObservableObject {
    enum Feature {
        case searchingRepositories
        case searchingUsers
    }

    @Published var feature: Feature

    init(feature: Feature) { self.feature = feature }
}

struct AppSeeder: Seedable {
    @Seed var seed = AppModel(feature: .searchingUsers)
    var objectWillChange: some Publisher { seed.objectWillChange }
}
