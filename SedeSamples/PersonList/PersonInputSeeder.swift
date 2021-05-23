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
    var objectWillChange: some Publisher {peopleRepository.objectWillChange}
    var updateCmd: Cmd<PersonInputView.Msg> = .ofMsg(.update)

    func receive(msg: PersonInputView.Msg) -> Cmd<PersonInputView.Msg> {
        switch msg {
        case .update:
            seed.people = peopleRepository.people
            return .none

        case .save:
            guard !seed.name.isEmpty else { return .none }
            peopleRepository.add(person: Person(name: seed.name, profile: seed.profile))
            seed.name = ""
            seed.profile = ""
            return .none
        }
    }
}
