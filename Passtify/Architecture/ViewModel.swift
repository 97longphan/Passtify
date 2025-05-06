//
//  ViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Foundation

typealias ViewModelDefinition = (ObservableObject & Identifiable & Hashable)

protocol ViewModel: ViewModelDefinition {}

extension ViewModel {
  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs === rhs
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}
