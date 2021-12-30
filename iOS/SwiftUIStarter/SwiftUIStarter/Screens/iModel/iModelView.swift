//
//  iModelView.swift
//  SwiftUIStarter
//
//  Created by Carl Hinkle on 12/28/21.
//

import SwiftUI
import ITwinMobile

struct iModelView: View {
    @StateObject private var vm: ViewModel
    
    
    init(iModel: iModel) {
        self._vm = StateObject(wrappedValue: ViewModel(with: iModel))
    }
    
    var body: some View {
        ITMSwiftUIContentView(application: vm.app)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle(vm.iModel.displayName ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                vm.closeIModel()
            }
    }
    
}

struct iModelView_Previews: PreviewProvider {
    static var previews: some View {
        iModelView(iModel: iModel(id: "123", displayName: "Na", name: "Na", description: nil, projectId: nil, extent: nil))
    }
}
