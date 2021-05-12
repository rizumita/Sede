//
// Created by Ryoichi Izumita on 2021/03/10.
//

import Foundation

class Memo: ObservableObject, Identifiable {
    let id: UUID
    @Published var content: String

    init(id: UUID, content: String) {
        self.id = id
        self.content = content
    }
}
