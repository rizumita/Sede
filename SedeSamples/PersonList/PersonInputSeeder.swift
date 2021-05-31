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
    @Seeded<PersonInputView.Model, PersonInputView.Msg> var seed

    @EnvironmentObject var peopleRepository: PeopleRepository
    var observedObjects: some ObservableObject { peopleRepository }
    var update: Cmd<PersonInputView.Msg> = .ofMsg(.update)

    func initialize() -> (PersonInputView.Model, Cmd<PersonInputView.Msg>) {
        (PersonInputView.Model(name: "test", profile: "", people: peopleRepository.people),
         .none)
    }

    func receive(msg: PersonInputView.Msg) -> Cmd<PersonInputView.Msg> {
        switch msg {
        case .resetFields:
            seed.name = ""
            seed.profile = ""
            return .none

        case .update:
            seed.people = peopleRepository.people
            return .none

        case .save:
            guard !seed.name.isEmpty else { return .none }
            peopleRepository.add(person: Person(name: seed.name, profile: seed.profile))
            return .batch(.ofMsg(.resetFields), .ofMsg(.update))
        }
    }
}
