//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import SwiftUI
import Sede

struct PersonInputView: View {
    @Seeder<Model, Msg> var seeder
    @Router<AppRoute> var router
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    TextField("Name", text: $seeder.name)
                    TextField("Profile", text: $seeder.profile)
                    Button("Save") { _seeder(.save) }
                }
                
                ForEach(seeder.people) { person in
                    NavigationLink(destination: router(.displayPerson(person))) { Text(person.name) }
                }
            }
            .navigationTitle("Input Person")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension PersonInputView {
    struct Model {
        var name: String
        var profile: String
        var people: [Person]
    }
    
    enum Msg {
        case save
    }
}


struct PersonInputView_Previews: PreviewProvider {
    static var previews: some View {
        PersonInputView()
    }
}
