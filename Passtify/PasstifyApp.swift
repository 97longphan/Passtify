//
//  PasstifyApp.swift
//  Passtify
//
//  Created by LONGPHAN on 29/4/25.
//

import SwiftUI
private let appAssembler: AppAssembler = AppAssembler()

final class AppSession: ObservableObject {
    @Published var isAuthenticated: Bool = false
}

@main
struct PasstifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var session = AppSession()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AppRootCoordinatorView(coordinator: appAssembler.resolver.resolved(AppRootCoordinator.self))
                .environmentObject(session)
        }.onChange(of: scenePhase) { newValue in
            if newValue == .background {
                session.isAuthenticated = false
            }
        }
    }
}
