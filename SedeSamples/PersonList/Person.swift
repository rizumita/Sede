//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import Foundation

struct Person: Identifiable {
    var id: UUID = UUID()
    var name: String
    var profile: String
}
