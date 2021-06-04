//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import SwiftUI
import Sede

struct PersonInputView: View {
    @Seeded<Model, Msg> var seed
    @Router<AppRoute> var router
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    TextField("Name", text: $seed.name)
                    TextField("Profile", text: $seed.profile)
                    Button("Save") { seed(.save) }
                }

                ForEach(seed.people) { person in
                    NavigationLink(destination: router(.displayPerson(person))) { Text(person.name) }
                }
            }
                .navigationTitle("Input Person")
        }
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension PersonInputView {
    struct Model: ObservableValue {
        static var published: [PartialKeyPath<PersonInputView.Model>] {
            \Self.people
        }

        var name: String
        var profile: String
        var people: [Person]
    }

    enum Msg {
        case print
        case resetFields
        case update
        case save
    }
}


struct PersonInputView_Previews: PreviewProvider {
    static var previews: some View {
        PersonInputView()
    }
}
