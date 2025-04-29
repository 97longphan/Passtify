//
//  Resolver+Extensions.swift
//  HundredDaysMVVM
//
//  Created by LONGPHAN on 24/4/25.
//

import Swinject

extension Resolver {
    @inlinable
    func resolved<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = resolve(serviceType) else {
            fatalError("\(serviceType) is required for this app. Please register \(serviceType) in an Assembly.")
        }
        return service
    }
    
    @inlinable
    func resolved<Service, Argument>(_ serviceType: Service.Type, argument: Argument) -> Service {
        guard let service = resolve(serviceType, argument: argument) else {
            fatalError("\(serviceType) with argument \(Argument.self) is required for this app. Please register \(serviceType) in an Assembly.")
        }
        return service
    }
}
