//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import Foundation

class PeopleRepository: ObservableObject {
    @Published private(set) var people: [Person] = []
    
    func add(person: Person) {
        people.append(person)
    }
}
