//
// Created by Ryoichi Izumita on 2021/05/13.
//

import Foundation
import Sede

struct AppModel {
    enum Feature {
        case searchingRepositories
        case searchingUsers
    }

    var feature: Feature
}

struct AppSeeder: Seeder {
    func initialize() -> Diad<AppModel, Never> {
        (AppModel(feature: .searchingUsers), .none)
    }
}
