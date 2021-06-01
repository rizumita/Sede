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

    func initialize() -> PersonInputView.Model {
        defer { seed(.print) }
        return PersonInputView.Model(name: "test", profile: "", people: peopleRepository.people)
    }

    func receive(msg: PersonInputView.Msg) {
        switch msg {
        case .print:
            print(_seed.model)

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
