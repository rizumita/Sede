//
//  DisableableButton.swift
//  SedeMemo
//
//  Created by 和泉田 領一 on 2021/03/20.
//
//

import SwiftUI

struct NavigationItemButton<Label>: View where Label: View {
    let enabled: Bool
    let action: () -> ()
    let label: () -> Label

    init(enabled: Bool, action: @escaping () -> (), label: @escaping () -> Label) {
        self.enabled = enabled
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: action, label: label)
            .disabled(!enabled)
    }
}

struct DisableableButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItemButton(enabled: true, action: { print("tapped") }, label: { Text("Button") })
    }
}
