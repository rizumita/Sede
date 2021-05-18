# Sede
Sede is a library for SwiftUI to bind a view and a model.

## Concept
Sede aimed to compatible with SwiftUI by fully utilizing SwiftUI features.
It can be loose coupling SwiftUI's View and Model, and Model can use View's Environment and EnvironmentObject freely.
View can reference Model and send messages freely.

## Install

You can install Sede by Swift Package Manager.

## How to use

### Create views

@Seeder provides a model's data and dispatches messages.

@Router provides a routing function.

```swift
import Sede

struct PersonInputView: View {
    @Seeder<Model, Msg> var seeder
    @Router<AppRoute> var router

    var body: some View {
        NavigationView {
            List {
                VStack {
                    TextField("Name", text: $seeder.name)   // Read Model.name by $seeder.name as binding
                    Button("Save") { _seeder(.save) }       // Send Msg.save to Seeder
                }

                ForEach(seeder.people) { person in          // Read model.people
                    NavigationLink(destination: router(.displayPerson(person))) { Text(person.name) }   // Route AppRoute.displayPerson(Person)
                }
            }
        }
    }
}

extension PersonInputView {
    struct Model {
        var name: String
        var people: [Person]
    }

    enum Msg {
        case save
    }
}

struct PersonDisplayView: View {
    @Seeder<Person, Never> var seeder

    var body: some View {
        VStack {
            Text(seeder.name)
        }
    }
}
```

### Create routing

`Routable.locate(route:)` method must return a view for Route. 

```swift
enum AppRoute {
    case inputPerson
    case displayPerson(Person)
}

struct AppRouter: Routable {
    func locate(route: AppRoute) -> some View {
        switch route {
        case .inputPerson:
            PersonInputView().seed(PersonInputSeeder())     // Set seeder typed for Seeder<Model, Msg>

        case .displayPerson(let person):
            PersonDisplayView().seed(PersonDisplaySeeder(person: person))   // Set seeder typed for Seeder<Person, Never>
        }
    }
}
```

### Create models

```swift
struct Person: Identifiable, Hashable {
    var id: UUID = UUID()
    var name: String
}

class PeopleRepository: ObservableObject {
    @Published private(set) var people: [Person] = []
    
    func add(person: Person) {
        people.append(person)
    }
}
```

### Create seeders

`Seedable.initialize()` method must return a tuple of a model and message wrapped by Cmd.

`Seedable.update(model:)` method must return a tuple of updated model and message wrapped by Cmd.

```swift
struct PersonInputSeeder: Seedable {
    @EnvironmentObject var peopleRepository: PeopleRepository
    
    func initialize() -> (PersonInputView.Model, Cmd<PersonInputView.Msg>) {    // Return Model and Msg wrapped by Cmd
        (.init(name: "", profile: "", people: []),
         .none)
    }
    
    func update(model: PersonInputView.Model) -> (PersonInputView.Model, Cmd<PersonInputView.Msg>) {    // Return update model and Msg wrapped by Cmd
        (.init(name: model.name, profile: model.profile, people: peopleRepository.people),
         .none)
    }
    
    func receive(model: PersonInputView.Model, msg: PersonInputView.Msg) {      // Handle msg with current model 
        switch msg {
        case .save:
            guard !model.name.isEmpty else { return }
            peopleRepository.add(person: Person(name: model.name, profile: model.profile))  // Repository sends with objectWillChanged by @Published and Self.update(model:Model) method will be called
        }
    }
}

struct PersonDisplaySeeder: Seedable {
    var person: Person

    func initialize() -> (Person, Cmd<Never>) {     // Return the person
        (person, .none)
    }
}
```

Cmd expresses a command to be run messages.

ex.
```
Cmd<Msg>.none                                                // Not run any message
Cmd<Msg>.ofMsg(.someMessage)                                 // Run .someMessage
Cmd<Msg>.batch([.ofMsg(.someMessage), .ofMsg(.someMessage)]) // Run .someMessage twice
```

### Create app

```swift
@main
struct PersonListApp: App {
    var body: some Scene {
        WindowGroup {
            AppRouter().base(.inputPerson)
                .environmentObject(PeopleRepository())  // Set the repository as environment object for seeders 
        }
    }
}
```

## License

MIT
