//
//  ProfileSeeder.swift
//  SedeSample
//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import SwiftUI
import Sede
import Combine

struct PersonInputSeeder: Seedable {
    @EnvironmentObject var peopleRepository: PeopleRepository
    @Seed var seed = PersonInputView.Model(name: "test", profile: "", people: [])

    func initialize() -> Cmd<PersonInputView.Msg> {
        .batch([
                   Task(peopleRepository.objectWillChange.debounce(for: .milliseconds(500),
                                                                   scheduler: DispatchQueue.main))
                       .attemptToMsg { _ in .update },
                   .ofMsg(.update)]
        )
    }

    func receive(msg: PersonInputView.Msg) {
        switch msg {
        case .update:
            seed.people = peopleRepository.people

        case .save:
            guard !seed.name.isEmpty else { return }

            // After adding, EnvironmentObject will publish, and PersonInputSeeder.initialize() will be invoked.
            peopleRepository.add(person: Person(name: seed.name, profile: seed.profile))

            seed.name = ""
            seed.profile = ""
        }
    }
}
