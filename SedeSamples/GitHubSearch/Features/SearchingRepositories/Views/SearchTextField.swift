//
//  SearchTextField.swift
//  SedeSamples
//
//  Created by 和泉田 領一 on 2021/03/28.
//
//

import SwiftUI

struct SearchTextField: View {
    @Binding var searchText: String
    var search: () -> ()

    var body: some View {
        TextField("Search text", text: $searchText, onCommit: search)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct SearchTextField_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextField(searchText: .constant("Text")) {}
    }
}
