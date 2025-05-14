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
    @Published var searchTerm: String = ""
    @Published var filteredList: [PasswordItemModel] = []
    
    init(passwordService: PasswordServiceProtocol) {
        self.passwordService = passwordService
        bind()
    }
    
    func setup(delegate: DeletedPasswordListViewModelDelegate) -> Self {
        self.delegate = delegate
        loadDeletedPasswords()
        return self
    }
    
    private func bind() {
        Publishers.CombineLatest($searchTerm, $deletedPasswordList)
            .map { term, list in
                if term.isEmpty {
                    return list
                } else {
                    return list.filter {
                        $0.label.localizedCaseInsensitiveContains(term) ||
                        $0.userName.localizedCaseInsensitiveContains(term)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$filteredList)
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
    
    func onActionSelectItem(item: PasswordItemModel) {
        delegate?.didSelectDeletedItem(item: item)
    }
}


