//
//  SearchField.swift
//  SedeSamples
//
//  Created by 和泉田 領一 on 2021/03/28.
//
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    var search: () -> ()

    var body: some View {
        HStack {
            SearchTextField(searchText: $searchText,
                            search: search)
                .padding()

            SearchButton(search: search)
        }
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(searchText: .constant("")) {}
    }
}
