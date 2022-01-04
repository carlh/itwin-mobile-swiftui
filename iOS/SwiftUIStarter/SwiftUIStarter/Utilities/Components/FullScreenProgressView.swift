//
//  FullScreenProgressView.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 1/4/22.
//

import SwiftUI

struct FullScreenProgressView: View {
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
            ProgressView {
                Text("Loading...")
            }
            .progressViewStyle(.circular)
            .padding(.horizontal, 24)
        }
    }
}

struct FullScreenProgressView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenProgressView()
    }
}
