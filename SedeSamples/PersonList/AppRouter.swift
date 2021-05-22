//
//  Created by Ryoichi Izumita on 2021/05/18.
//

import SwiftUI
import Sede

enum AppRoute {
    case inputPerson
    case displayPerson(Person)
}

struct AppRouter: Routable {
    func locate(route: AppRoute) -> some View {
        switch route {
        case .inputPerson:
            PersonInputView()
                .seed(PersonInputSeeder())

        case .displayPerson(let person):
            PersonDisplayView()
                .seed(VariableSeeder(seed: person))
        }
    }
}
