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
    case cardList(CardListViewModel)
}


class AppRootCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var newPasswordViewModel: NewPasswordViewModel?
    @Published var newCardViewModel: NewCardViewModel?
    @Published private(set) var homeViewModel: HomeViewModel!
    @Published private(set) var authenViewModel: AuthenticationViewModel!
    @Published var exportFileURL: ExportFile?
    @Published var isImportingZip: Bool = false
    
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
    
    func pushToCardList() {
        let vm = resolver.resolved(CardListViewModel.self).setup(delegate: self)
        path.append(.cardList(vm))
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
    
    func presentAddNewCard() {
        newCardViewModel = resolver.resolved(NewCardViewModel.self).setup(delegate: self)
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

extension AppRootCoordinator {
    func reloadCardList() {
        if case let .cardList(vm) = path.last {
            vm.loadCards()
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
    func didPressCard() {
        pushToCardList()
    }
    
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


extension AppRootCoordinator: CardListViewModelDelegate {
    func didSelectCard() {
        //
    }
    
    func didAddNewCard() {
        presentAddNewCard()
    }
}

extension AppRootCoordinator: NewCardViewModelDelegate {
    func dismissNewCard() {
        newCardViewModel = nil
    }
    
    func didAddedNewCard() {
        newCardViewModel = nil
        reloadCardList()
    }
}
