//
//  iModelViewModel.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import Foundation
import ITwinMobile

extension iModelView {
    @MainActor class ViewModel: ObservableObject {
        @Published var app: SwiftUIModelApplication
        let iModel: iModel 
        
        init(with iModel: iModel) {
            self.iModel = iModel
            app = SwiftUIModelApplication()
            app.vm = self
        }
    }
}
