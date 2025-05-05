//
//  HomeViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 30/4/25.
//

import Combine
import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didPressPassword()
}

@Observable

class HomeViewModel: ViewModel {
    private weak var delegate: HomeViewModelDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    var categories: [HomeItemCategoryModel] = HomeItemCategoryType.allCases.map {
        HomeItemCategoryModel(type: $0, count: 0)
    }
    
    func setup(delegate: HomeViewModelDelegate) -> Self {
        self.delegate = delegate
        bind()
        return self
    }
    
    private func bind() {
    }
    
    func handleCategoryTap(item: HomeItemCategoryModel) {
        switch item.type {
        case .password:
            delegate?.didPressPassword()
        default: break
        }
    }
}
