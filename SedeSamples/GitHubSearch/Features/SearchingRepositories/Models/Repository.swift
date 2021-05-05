//
// Created by 和泉田 領一 on 2021/03/28.
//

import Foundation

struct Repository: Identifiable, Decodable {
    var id: Int
    var name: String
    var url: URL
    var description: String?

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case url = "html_url"
        case description
    }
}
