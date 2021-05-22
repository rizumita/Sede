//
//  Created by Ryoichi Izumita on 2021/05/18.
//

import SwiftUI
import Sede

struct PersonDisplayView: View {
    @Seeder<Person, Never> var seeder

    var body: some View {
        VStack {
            Text(seeder.name)
            Text(seeder.profile)
        }
    }
}

struct PersonDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDisplayView().seed(model: Person(name: "Preview", profile: "Profile"), receive: { (_: Never) in .none })
    }
}
