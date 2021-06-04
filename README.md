# Sede
Sede is a library for SwiftUI to connect views and models, and to provide routing.

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
        case resetFields
        case update
        case save
    }
}

struct PersonDisplayView: View {
    @Seeded<Person, Never> var seed

    var body: some View {
        VStack {
            Text(seed.name)
            Text(seed.profile)
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
            PersonInputView().seed(PersonInputSeeder())

        case .displayPerson(let person):
            PersonDisplayView().seed(VariableSeeder(person))
        }
    }
}
```

### Create models

```swift
struct Person: Identifiable {
    var id: UUID = UUID()
    var name: String
    var profile: String
}

class PeopleRepository: ObservableObject {
    @Published private(set) var people: [Person] = []

    func add(person: Person) {
        people.append(person)
    }
}
```

### Create seeders

```swift
struct PersonInputSeeder: Seedable {
    @Seeding<PersonInputView.Model, PersonInputView.Msg> var seed

    @EnvironmentObject var peopleRepository: PeopleRepository
    var observedObjects: some ObservableObject { peopleRepository }

    func initialize() {
        seed.initialize(PersonInputView.Model(name: "test", profile: "", people: peopleRepository.people))
    }

    func update() {
        seed(.update)
    }

    func receive(msg: PersonInputView.Msg) {
        switch msg {
        case .resetFields:
            seed.name = ""
            seed.profile = ""

        case .update:
            seed.people = peopleRepository.people

        case .save:
            guard !seed.name.isEmpty else { return }
            peopleRepository.add(person: Person(name: seed.name, profile: seed.profile))
            seed {
                Msg.resetFields
                Msg.update
                Msg.print
            }
        }
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

Task expressed an async task to be run messages.

ex.
```swift
Task(publisher).attemptToMsg { _ in .update }   // When the publisher sends value, Msg.update is sent. 
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
