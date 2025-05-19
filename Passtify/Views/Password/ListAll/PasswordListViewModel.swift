//
//  PasswordListViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 1/5/25.
//

import Combine
import Foundation

protocol PasswordListViewModelDelegate: AnyObject {
    func didCreateNewPassword()
    func didSelectItem(item: PasswordItemModel)
}

class PasswordListViewModel: ViewModel {
    private weak var delegate: PasswordListViewModelDelegate?
    private let passwordService: PasswordServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    @Published var passwordList: [PasswordItemModel] = []
    @Published var searchTerm: String = ""
    @Published var filteredList: [PasswordItemModel] = []
    @Published var groupedList: [String: [PasswordItemModel]] = [:]
    
    init(passwordService: PasswordServiceProtocol) {
        self.passwordService = passwordService
        bind()
    }
    
    func setup(delegate: PasswordListViewModelDelegate) -> Self {
        self.delegate = delegate
        return self
    }
    
    private func bind() {
        Publishers.CombineLatest($searchTerm, $passwordList)
            .map { term, list in
                if term.isEmpty {
                    return list
                } else {
                    return list.filter {
                        $0.domainOrLabel.localizedCaseInsensitiveContains(term) ||
                        $0.userName.localizedCaseInsensitiveContains(term)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filtered in
                self?.filteredList = filtered
                
                let grouped = Dictionary(grouping: filtered) { item -> String in
                    let first = item.domainOrLabel.first?.uppercased() ?? "#"
                    return first.range(of: "[A-Z]", options: .regularExpression) != nil ? first : "#"
                }
                self?.groupedList = grouped.mapValues { $0.sorted { $0.domainOrLabel < $1.domainOrLabel } }
            }
            .store(in: &cancellables)
    }
    
    func onActionCreateNewPassword() {
        delegate?.didCreateNewPassword()
    }
    
    func onActionSelectItem(item: PasswordItemModel) {
        delegate?.didSelectItem(item: item)
    }
    
    func loadPasswords() {
        passwordService.loadPasswords()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error)
                }
            } receiveValue: { [weak self] passwords in
                self?.passwordList = passwords
            }
            .store(in: &cancellables)
    }
}
