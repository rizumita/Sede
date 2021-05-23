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
    @Seeder<Model, Msg> var seeder
    @Router<AppRoute> var router

    var body: some View {
        NavigationView {
            List {
                VStack {
                    TextField("Name", text: $seeder.name)
                    Button("Save") { _seeder(.save) }
                }

                ForEach(seeder.people) { person in
                    NavigationLink(destination: router(.displayPerson(person))) { Text(person.name) }
                }
            }.navigationTitle("Input Person")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

extension PersonInputView {
    // Model is class or struct.
    class Model: ObservableObject {
        var name: String
        @Published var people: [Person]

        init(name: String, people: [Person]) {
            self.name = name
            self.people = people
        }
    }

    enum Msg {
        case update
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
            PersonInputView().seed(PersonInputSeeder())

        case .displayPerson(let person):
            PersonDisplayView().seed(VariableSeeder(seed: person))
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

```swift
struct PersonInputSeeder: Seedable {
    @EnvironmentObject var peopleRepository: PeopleRepository
    @Seed var seed = PersonInputView.Model(name: "test", people: [])

    func initialize() -> Cmd<PersonInputView.Msg> {
        .batch([
                   // When the peopleRepository is updated, the `update` message is sent.
                   Task(peopleRepository.objectWillChange.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main))
                       .attemptToMsg { _ in .update },
                   // The `update` message is sent immediately.
                   .ofMsg(.update)
               ])
    }

    func receive(msg: PersonInputView.Msg) -> Cmd<PersonInputView.Msg> {
        print(msg)
        switch msg {
        case .update:
            seed.people = peopleRepository.people
            return .none

        case .save:
            guard !seed.name.isEmpty else { return .none }

            peopleRepository.add(person: Person(name: seed.name))

            seed.name = ""
            return .none
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
