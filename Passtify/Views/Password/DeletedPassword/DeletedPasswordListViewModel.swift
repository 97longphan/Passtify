//
//  DeletedPasswordListViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Combine
import Foundation
protocol DeletedPasswordListViewModelDelegate: AnyObject {
    func didSelectDeletedItem(item: PasswordItemModel)
}

class DeletedPasswordListViewModel: ViewModel {
    private weak var delegate: DeletedPasswordListViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var deletedPasswordList: [PasswordItemModel] = []
    
    init(passwordService: PasswordServiceProtocol) {
        self.passwordService = passwordService
    }
    
    func setup(delegate: DeletedPasswordListViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        loadDeletedPasswords()
        return self
    }
    
    private func bind() {
        // Optional Combine bindings here
    }
    
    func onActionSelectItem(item: PasswordItemModel) {
        delegate?.didSelectDeletedItem(item: item)
    }
    
    func loadDeletedPasswords() {
        passwordService.loadDeletedPasswords()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] passwords in
                self?.deletedPasswordList = passwords
            }
            .store(in: &cancellables)
    }
}

