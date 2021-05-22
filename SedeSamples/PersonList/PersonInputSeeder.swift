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
    var objectWillChange: some Publisher {
        peopleRepository.objectWillChange
    }

    func initialize() -> Cmd<PersonInputView.Msg> {
        seed.people = peopleRepository.people
        return .none
    }

    // If self.objectWillChange sends some outputs, update() will invoke.
    func update() {
        seed.people = peopleRepository.people
    }

    func receive(msg: PersonInputView.Msg) {
        switch msg {
        case .save:
            guard !seed.name.isEmpty else { return }

            // After adding, EnvironmentObject will publish, and PersonInputSeeder.initialize() will be invoked.
            peopleRepository.add(person: Person(name: seed.name, profile: seed.profile))

            seed.name = ""
            seed.profile = ""
            seed.people = peopleRepository.people
        }
    }
}
