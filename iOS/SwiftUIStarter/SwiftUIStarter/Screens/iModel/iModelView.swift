//
//  iModelView.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import SwiftUI
import ITwinMobile

struct iModelView: View {
    @EnvironmentObject private var app: SwiftUIModelApplication
    @StateObject private var vm: ViewModel
    
    init(iModel: iModel) {
        self._vm = StateObject(wrappedValue: ViewModel(with: iModel))
    }
    
    var body: some View {
        ZStack {
            if let app = vm.app {
                ITMSwiftUIContentView(application: app)
                    .edgesIgnoringSafeArea(.all)
                    .navigationTitle(vm.iModel.displayName ?? "")
                    .navigationBarTitleDisplayMode(.inline)
                    .onDisappear {
                        vm.closeIModel()
                    }
            } else {
                VStack(alignment: .center) {
                    ProgressView("Loading...")
                        .progressViewStyle(.linear)
                }
            }
        }
        .onAppear {
            vm.app = app
        }
    }
    
}

struct iModelView_Previews: PreviewProvider {
    static var previews: some View {
        iModelView(iModel: iModel(id: "123", displayName: "Na", name: "Na", description: nil, projectId: nil, extent: nil))
    }
}
