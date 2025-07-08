//
//  AuthenticationViewModel.swift
//  Passtify
//
//  Created by LONGPHAN on 7/5/25.
//

import Foundation
import Combine
enum AuthState {
    case locked
    case authenticating
    case unlocked
}

enum AuthTrigger {
    case automatic  // Ví dụ: khi vào view, khi app active
    case manual     // Người dùng bấm nút
}

final class AuthenticationViewModel: ObservableObject {
    private let authService: AuthServiceProtocol
    let session: AppSession
    private var cancellables = Set<AnyCancellable>()
    @Published var toast: Toast?
    
    init(authService: AuthServiceProtocol,
         session: AppSession) {
        self.authService = authService
        self.session = session
    }
    
    func authenticate(_ authTrigger: AuthTrigger) {
#if targetEnvironment(simulator) || DEBUG
        session.authState = .unlocked
#else
        switch authTrigger {
        case .automatic:
            guard session.authState != .authenticating else { return }
            session.authState = .authenticating
            startAuthen()
        case .manual:
            startAuthen()
        }
#endif
    }
    
    private func startAuthen() {
        authService.authenticateUser()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    if error.needShowToastError {
                        self?.toast = Toast(message: error.msg, type: .error)
                    }
                case .finished:
                    break
                }
            } receiveValue: { [weak self] in
                self?.session.authState = .unlocked
            }
            .store(in: &cancellables)
    }
}
