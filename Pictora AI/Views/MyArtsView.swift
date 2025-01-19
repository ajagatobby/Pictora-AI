//
//  MyArtsView.swift
//  Pictora AI
//
//  Created by Abdulbasit Ajaga on 19/01/2025.
//

import SwiftUI

struct MyArtsView: View {
    var body: some View {
        ZStack {
            GradientBackground2()
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ArtCollectionGrid(arts: myArts)
                        .padding(.vertical, 50)
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    MyArtsView()
}
