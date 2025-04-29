//
//  AppAssembler.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

class AppAssembler {
    private let assembler: Assembler
    
    var resolver: Resolver { self.assembler.resolver }
    
    init() {
        self.assembler = Assembler([
            CoordinatorAssembly(),
            ServiceAssembly(),
            ViewModelAssembly()
        ])
    }
}
