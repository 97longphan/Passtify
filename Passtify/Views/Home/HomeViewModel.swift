////
////  HomeViewModel.swift
////  Passtify
////
////  Created by LONGPHAN on 30/4/25.
////
//
//import Combine
//import Foundation
//
//protocol HomeViewModelDelegate: AnyObject {
//    func didPressPassword()
//    func didPressDeletedPassword()
//    func didExportData(url: URL)
//    func didImportData()
//}
//
//class HomeViewModel: ViewModel {
//    private weak var delegate: HomeViewModelDelegate?
//    private var cancellables = Set<AnyCancellable>()
//    private let passwordService: PasswordServiceProtocol
//    private let fileService: FileServiceProtocol
//    
//    
//    init(passwordService: PasswordServiceProtocol, fileService: FileServiceProtocol) {
//        self.passwordService = passwordService
//        self.fileService = fileService
//    }
//    
//    @Published var categories: [HomeItemCategoryModel] = HomeItemCategoryType.allCases.map {
//        HomeItemCategoryModel(type: $0, count: 0)
//    }
//    
//    func setup(delegate: HomeViewModelDelegate) -> Self {
//        self.delegate = delegate
//        bind()
//        loadPasswords()
//        return self
//    }
//    
//    private func bind() {
//        // Implement Combine bindings if needed
//    }
//    
//    func handleCategoryTap(item: HomeItemCategoryModel) {
//        switch item.type {
//        case .password:
//            delegate?.didPressPassword()
//        case .deleted:
//            delegate?.didPressDeletedPassword()
//        case .exportData:
//            fileService.exportEncryptedDataAsZip()
//                .sink { completion in
//                    if case .failure(let error) = completion {
//                        print("Export failed:", error)
//                    }
//                } receiveValue: { [weak self] url in
//                    self?.delegate?.didExportData(url: url)
//                }.store(in: &cancellables)
//        case .importData:
//            delegate?.didImportData()
//        }
//    }
//    
//    func importDataFrom(url: URL) {
//        fileService.importEncryptedDataFromZip(url)
//            .sink { completion in
//                if case .failure(let error) = completion {
//                    print("Export failed:", error)
//                }
//            } receiveValue: { [weak self] _ in
//                self?.loadCount()
//            }.store(in: &cancellables)
//    }
//    
//    private func updateCount(for type: HomeItemCategoryType, count: Int) {
//        if let index = categories.firstIndex(where: { $0.type == type }) {
//            categories[index].count = count
//        }
//    }
//    
//    private func loadPasswords() {
//        passwordService.loadPasswords()
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print(error)
//                }
//            } receiveValue: { [weak self] passwords in
//                self?.updateCount(for: .password, count: passwords.count)
//            }
//            .store(in: &cancellables)
//    }
//    
//    private func loadDeletePasswords() {
//        passwordService.loadDeletedPasswords()
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    print(error)
//                }
//            } receiveValue: { [weak self] passwords in
//                self?.updateCount(for: .deleted, count: passwords.count)
//            }
//            .store(in: &cancellables)
//    }
//    
//    func loadCount() {
//        loadPasswords()
//        loadDeletePasswords()
//    }
//}
