//
//  AppRootCoordinator.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Foundation
import Swinject
import FirebaseAuth
import SwiftUI

enum AppRoute: Hashable {
    case passwordList(PasswordListViewModel)
    case detailPassword(DetailPasswordViewModel)
}


class AppRootCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var newPasswordViewModel: NewPasswordViewModel?
    
    @Published private(set) var homeViewModel: HomeViewModel!
    @Published var passwordListViewModel: PasswordListViewModel?
    @Published var detailPasswordViewModel: DetailPasswordViewModel?
    
    let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
        self.homeViewModel = resolver.resolved(HomeViewModel.self).setup(delegate: self)
    }
    
    func pushToPasswordList() {
        let vm = resolver.resolved(PasswordListViewModel.self).setup(delegate: self)
        path.append(.passwordList(vm))
    }
    
    func pushToDetailPassword(item: PasswordItemModel) {
        let vm = resolver.resolved(DetailPasswordViewModel.self, argument: item).setup(delegate: self)
        path.append(.detailPassword(vm))
    }
    
    func presentNewPassword() {
        newPasswordViewModel = resolver.resolved(NewPasswordViewModel.self).setup(delegate: self)
    }
    
    func pop() {
        path.removeLast()
    }
}

extension AppRootCoordinator {
    func reloadPasswordList() {
        if case let .passwordList(vm) = path.last {
            vm.loadPasswords()
        }
    }
}

extension AppRootCoordinator: HomeViewModelDelegate {
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
        reloadPasswordList()
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

