//
// Created by Ryoichi Izumita on 2021/05/13.
//

import Foundation
import Sede
import Combine
import SwiftUI

class AppModel: ObservableObject {
    enum Feature {
        case searchingRepositories
        case searchingUsers
    }

    @Published var feature: Feature

    init(feature: Feature) { self.feature = feature }
}

struct AppSeeder: Seedable {
    @Seed(AppModel(feature: .searchingUsers)) var seed
    var objectWillChange: some Publisher { seed.objectWillChange }
}
