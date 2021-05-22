//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import Foundation
import SwiftUI

class PeopleRepository: ObservableObject {
    @Published private(set) var people: [Person] = []

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.add(person: Person(name: "after", profile: ""))
        }
    }

    func add(person: Person) {
        people.append(person)
    }
}
