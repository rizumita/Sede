//
//  Created by Ryoichi Izumita on 2021/05/18.
//

import SwiftUI
import Sede

@main
struct PersonListApp: App {
    var body: some Scene {
        WindowGroup {
            AppRouter().base(.inputPerson)
                .environmentObject(PeopleRepository())
        }
    }
}
