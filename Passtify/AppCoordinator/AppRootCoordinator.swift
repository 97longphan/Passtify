//
//  AppRootCoordinator.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Foundation
import Swinject
import SwiftUI
struct ExportFile: Identifiable {
    let id = UUID()
    let url: URL
}

enum AppRoute: Hashable {
    case passwordList(PasswordListViewModel)
    case detailPassword(DetailPasswordViewModel)
    case deletedPasswordList(DeletedPasswordListViewModel)
    case deletedDetailPassword(DetailDeletedPasswordViewModel)
}


class AppRootCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var newPasswordViewModel: NewPasswordViewModel?
    @Published private(set) var homeViewModel: HomeViewModel!
    @Published private(set) var authenViewModel: AuthenticationViewModel!
    @Published var didCancelLastAttempt = true
    @Published var isAuthenticated = false
    @Published var exportFileURL: ExportFile?
    @Published var isImportingZip: Bool = false
    private let authService: AuthServiceProtocol = AuthService()
    
    
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.homeViewModel = resolver.resolved(HomeViewModel.self).setup(delegate: self)
        self.authenViewModel = resolver.resolved(AuthenticationViewModel.self)
    }
    
    func pushToPasswordList() {
        let vm = resolver.resolved(PasswordListViewModel.self).setup(delegate: self)
        path.append(.passwordList(vm))
    }
    
    func pushToDetailPassword(item: PasswordItemModel) {
        let vm = resolver.resolved(DetailPasswordViewModel.self, argument: item).setup(delegate: self)
        path.append(.detailPassword(vm))
    }
    
    func pushToDeletedList() {
        let vm = resolver.resolved(DeletedPasswordListViewModel.self).setup(delegate: self)
        path.append(.deletedPasswordList(vm))
    }
    
    func pushToDetailDeletedPassword(item: PasswordItemModel) {
        let vm = resolver.resolved(DetailDeletedPasswordViewModel.self, argument: item).setup(delegate: self)
        path.append(.deletedDetailPassword(vm))
    }
    
    func presentNewPassword() {
        newPasswordViewModel = resolver.resolved(NewPasswordViewModel.self).setup(delegate: self)
    }
    
    func presentExportData(url: URL) {
        exportFileURL = ExportFile(url: url)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func auth(completion:  @escaping ((Bool) -> Void)) {
        authService.authenticateUser { [weak self] success, errorCode in
            DispatchQueue.main.async {
                if success {
                    self?.didCancelLastAttempt = false
                } else {
                    if errorCode == .userCancel || errorCode == .systemCancel {
                        self?.didCancelLastAttempt = true
                    }
                }
                completion(success)
            }
        }
    }
}

extension AppRootCoordinator {
    func reloadPasswordList() {
        if case let .passwordList(vm) = path.last {
            vm.loadPasswords()
        }
    }
    
    func reloadDeletedPasswordList() {
        if case let .deletedPasswordList(vm) = path.last {
            vm.loadDeletedPasswords()
        }
    }
}

extension AppRootCoordinator: DetailDeletedPasswordViewModelDelegate {
    func didRecoverPassword() {
        pop()
        reloadDeletedPasswordList()
    }
    
    func didPermanentlyDeletePassword() {
        pop()
        reloadDeletedPasswordList()
    }
}

extension AppRootCoordinator: DeletedPasswordListViewModelDelegate {
    func didSelectDeletedItem(item: PasswordItemModel) {
        pushToDetailDeletedPassword(item: item)
    }
    
}

extension AppRootCoordinator: HomeViewModelDelegate {
    func didImportData() {
        isImportingZip = true
    }
    
    func didExportData(url: URL) {
        presentExportData(url: url)
    }
    
    func didPressDeletedPassword() {
        pushToDeletedList()
    }
    
    func didPressPassword() {
        pushToPasswordList()
    }
}

extension AppRootCoordinator: PasswordListViewModelDelegate {
    func didSelectItem(item: PasswordItemModel) {
        pushToDetailPassword(item: item)
    }
    
    func didCreateNewPassword() {
        presentNewPassword()
    }
}

extension AppRootCoordinator: DetailPasswordViewModelDelegate {
    func didDeletedPassword() {
        pop()
    }
}

extension AppRootCoordinator: NewPasswordViewModelDelegate {
    func didCreatedNewPassword() {
        newPasswordViewModel = nil
        reloadPasswordList()
        
    }
    
    func dismissNewPassword() {
        newPasswordViewModel = nil
    }
}

