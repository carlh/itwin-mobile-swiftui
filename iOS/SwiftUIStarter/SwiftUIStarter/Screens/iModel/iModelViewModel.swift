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
        @Published var app: SwiftUIModelApplication? = nil {
            didSet {
                app?.vm = self
            }
        }
        
        let iModel: iModel
        
        init(with iModel: iModel) {
            self.iModel = iModel
        }
        
        func closeIModel() {
            app?.closeIModel()
        }
    }
}
