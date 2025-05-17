//
//  DetailPasswordView.swift
//  Passtify
//
//  Created by LONGPHAN on 5/5/25.
//

import SwiftUI

struct DetailPasswordView: View {
    @ObservedObject var viewModel: DetailPasswordViewModel
    @State private var editing = false
    @State private var tempItem: PasswordItemModel = .empty
    @State private var showActionSheetDelete = false
    @EnvironmentObject var toastManager: ToastManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if editing {
                    EditableHeaderCard()
                    EditableInfoCard()
                    EditableNoteCard()
                } else {
                    HeaderCard()
                    InfoCard()
                    if let note = viewModel.passwordItem.notes,
                       !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        NoteCard(note: note)
                    }
                    
                }
                
                if editing {
                    DeleteButtonSection()
                }
                
                Spacer(minLength: 32)
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("key.password_details".localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(editing)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if editing {
                    Button("key.cancel".localized) {
                        editing = false
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(editing ? "key.save".localized : "key.edit".localized) {
                    if editing {
                        viewModel.updateItem(newItem: tempItem)
                    } else {
                        tempItem = viewModel.passwordItem
                    }
                    editing.toggle()
                }
            }
        }
    }
    
    private func HeaderCard() -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: 48, height: 48)
                .overlay(Text(viewModel.passwordItem.label.prefix(1).uppercased())
                    .font(.title2).bold())
            
            VStack(alignment: .leading) {
                Text(viewModel.passwordItem.label)
                    .font(.title3).bold()
                Text(String(format: "key.modified_value".localized, formattedDate(viewModel.passwordItem.creationDate)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
    
    private func InfoCard() -> some View {
        VStack(spacing: 12) {
            InfoRow(title: "key.username".localized, value: viewModel.passwordItem.userName) {
                copyToClipboard(viewModel.passwordItem.userName, label: "key.username".localized)
            }
            InfoRow(title: "key.password".localized, value: "••••••••") {
                copyToClipboard(viewModel.passwordItem.password, label: "key.password".localized)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
    
    private func NoteCard(note: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("key.note".localized)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(note)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
    
    
    private func EditableHeaderCard() -> some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(UIColor.systemGray5))
                .frame(width: 48, height: 48)
                .overlay(Text(tempItem.label.prefix(1).uppercased())
                    .font(.title2).bold())
            
            VStack(alignment: .leading) {
                TextField("key.username", text: $tempItem.label)
                    .font(.title3).bold()
                Text(String(format: "key.modified_value".localized, formattedDate(viewModel.passwordItem.creationDate)))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
    
    private func EditableInfoCard() -> some View {
        VStack(spacing: 12) {
            EditableRow(title: "key.username".localized, text: $tempItem.userName)
            EditableRow(title: "key.password".localized, text: $tempItem.password)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
    }
    
    private func EditableNoteCard() -> some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: Binding(
                get: { tempItem.notes ?? "" },
                set: { tempItem.notes = $0.isEmpty ? nil : $0 }
            ))
            .frame(height: 100)
            .scrollContentBackground(.hidden) // Ẩn nền cuộn mặc định (iOS 16+)
            .background(Color.white)
            .foregroundColor((tempItem.notes ?? "").isEmpty ? .gray : .primary)
            
            if (tempItem.notes ?? "").isEmpty {
                Text("key.add_note".localized)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
                    .padding(.horizontal, 5)
            }
        }.padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, y: 1)
        
    }
    
    private func DeleteButtonSection() -> some View {
        Button(role: .destructive) {
            showActionSheetDelete = true
        } label: {
            Text("key.delete_password".localized)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
        )
        .confirmationDialog("", isPresented: $showActionSheetDelete, titleVisibility: .hidden) {
            Button("key.delete_password".localized, role: .destructive) {
                viewModel.deleteItem()
            }
            Button("key.cancel".localized, role: .cancel) {}
        } message: {
            Text("key.password_delete_warning".localized)
        }
    }
    
    private func InfoRow(title: String, value: String, onTap: @escaping () -> Void) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: onTap) {
                Image(systemName: "doc.on.doc")
            }
        }
    }
    
    private func EditableRow(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            TextField("", text: text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func copyToClipboard(_ value: String, label: String) {
        UIPasteboard.general.string = value
        toastManager.show(String(format: "key.copied_value".localized, label))
    }
    
}
