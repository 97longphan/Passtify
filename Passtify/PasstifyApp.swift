//
//  PasstifyApp.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import SwiftUI
private let appAssembler: AppAssembler = AppAssembler()

@main
struct PasstifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            AppRootCoordinatorView(coordinator: appAssembler.resolver.resolved(AppRootCoordinator.self))
        }
    }
}
