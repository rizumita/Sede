//
// Created by Ryoichi Izumita on 2021/05/13.
//

import Foundation
import Sede
import Combine
import SwiftUI

struct AppModel: ObservableValue {
    enum Feature {
        case searchingRepositories
        case searchingUsers
    }

    var feature: Feature
    
    static var published: [PartialKeyPath<AppModel>] {
        \Self.feature
    }
}

struct AppSeeder: Seedable {
    @Seed<AppModel, Never> var seed

    func initialize() -> AppModel {
        .init(feature: .searchingUsers)
    }
}
