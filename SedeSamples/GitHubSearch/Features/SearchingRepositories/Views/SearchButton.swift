//
//  SearchButton.swift
//  SedeSamples
//
//  Created by 和泉田 領一 on 2021/03/28.
//
//

import SwiftUI

struct SearchButton: View {
    var search: () -> ()

    var body: some View {
        Button(action: search,
               label: {
                   Image(systemName: "magnifyingglass")
                       .resizable()
                       .frame(width: 30, height: 30)
               })
    }
}

struct SearchButton_Previews: PreviewProvider {
    static var previews: some View {
        SearchButton {}
    }
}
