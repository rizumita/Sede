//
//  Created by Ryoichi Izumita on 2021/05/18.
//

import SwiftUI
import Sede

struct PersonDisplayView: View {
    @Seeded<Person, Never> var seed

    var body: some View {
        VStack {
            Text(seed.name)
            Text(seed.profile)
        }
    }
}

struct PersonDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDisplayView().seed(model: Person(name: "Preview", profile: "Profile"))
    }
}
