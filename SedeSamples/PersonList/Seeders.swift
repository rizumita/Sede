//
//  ProfileSeeder.swift
//  SedeSample
//
//  Created by Ryoichi Izumita on 2021/05/16.
//

import SwiftUI
import Sede

struct PersonInputSeeder: Seedable {
    @EnvironmentObject var peopleRepository: PeopleRepository
    
    func initialize() -> (PersonInputView.Model, Cmd<PersonInputView.Msg>) {
        (.init(name: "", profile: "", people: []),
         .none)
    }
    
    func update(model: PersonInputView.Model) -> (PersonInputView.Model, Cmd<PersonInputView.Msg>) {
        (.init(name: model.name, profile: model.profile, people: peopleRepository.people),
         .none)
    }
    
    func receive(model: PersonInputView.Model, msg: PersonInputView.Msg) {
        switch msg {
        case .save:
            guard !model.name.isEmpty else { return }
            peopleRepository.add(person: Person(name: model.name, profile: model.profile))
        }
    }
}

struct PersonDisplaySeeder: Seedable {
    var person: Person

    func initialize() -> (Person, Cmd<Never>) {
        (person, .none)
    }
}
