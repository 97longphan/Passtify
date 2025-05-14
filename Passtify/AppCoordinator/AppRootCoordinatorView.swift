//
//  AppRootCoordinatorView.swift
//  Passtify
//
//  Created by LONGPHAN on 24/4/25.
//

import SwiftUI

struct AppRootCoordinatorView: View {
    @ObservedObject var coordinator: AppRootCoordinator
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var session: AppSession
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        if session.isAuthenticated {
            ZStack {
                homeView()
                if toastManager.isPresented {
                    VStack {
                        Spacer()
                        OverlayToastView(message: toastManager.message, type: toastManager.type)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.horizontal)
                    }
                }
            }
            
            
        } else {
            NavigationStack {
                AuthenticationView(viewModel: coordinator.authenViewModel)
            }
        }
    }
    
    @ViewBuilder
    private func homeView() -> some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: coordinator.homeViewModel)
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .passwordList(let vm):
                        PasswordListView(viewModel: vm)
                    case .detailPassword(let vm):
                        DetailPasswordView(viewModel: vm)
                    case .deletedPasswordList(let vm):
                        DeletedPasswordListView(viewModel: vm)
                    case .deletedDetailPassword(let vm):
                        DetailDeletedPasswordView(viewModel: vm)
                    }
                }
        }
        .sheet(item: $coordinator.newPasswordViewModel) { vm in
            NewPasswordView(viewModel: vm)
        }
        .sheet(item: $coordinator.exportFileURL) { file in
            ShareSheet(activityItems: [file.url])
        }
        .sheet(isPresented: $coordinator.isImportingZip) {
            DocumentPicker { pickedURL in
                coordinator.homeViewModel.importDataFrom(url: pickedURL)
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}

import UniformTypeIdentifiers

struct DocumentPicker: UIViewControllerRepresentable {
    var onDocumentsPicked: (URL) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onDocumentsPicked: onDocumentsPicked)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.zip], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var onDocumentsPicked: (URL) -> Void
        
        init(onDocumentsPicked: @escaping (URL) -> Void) {
            self.onDocumentsPicked = onDocumentsPicked
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let first = urls.first {
                onDocumentsPicked(first)
            }
        }
    }
}
