import SwiftUI

import SwiftUI

struct NewCardView: View {
    @ObservedObject var viewModel: NewCardViewModel
    @State private var cardNumberFormatted: String = ""

    var body: some View {
        NavigationView {
            Form {
                // SECTION 1: Card Details
                Section {
                    ZStack(alignment: .trailing) {
                        TextField("key.card_number".localized, text: $cardNumberFormatted)
                            .keyboardType(.numberPad)
                            .onChange(of: cardNumberFormatted) { newValue in
                                var raw = newValue.unformattedCardNumber()
                                if raw.count > Constants.AppCard.validCardNumberLength {
                                    raw = String(raw.prefix(16))
                                }
                                let formatted = raw.formattedCardNumber()
                                if formatted != cardNumberFormatted {
                                    cardNumberFormatted = formatted
                                }
                                if viewModel.input.cardNumber != raw {
                                    viewModel.input.cardNumber = raw
                                }
                            }
                            .padding(.trailing, 45)

                        if viewModel.input.cardType != .unknown {
                            Image(viewModel.input.cardType.logoAssetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                        }
                    }

                    TextField("key.name_on_card".localized, text: $viewModel.input.cardHolderName)
                        .autocapitalization(.words)

                    HStack(spacing: 16) {
                        TextField("key.expiry_date".localized, text: $viewModel.input.expiryDate)
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.input.expiryDate) { newValue in
                                let digitsOnly = newValue.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
                                let trimmed = String(digitsOnly.prefix(4))
                                if trimmed.count >= 3 {
                                    let mm = trimmed.prefix(2)
                                    let yy = trimmed.suffix(from: trimmed.index(trimmed.startIndex, offsetBy: 2))
                                    viewModel.input.expiryDate = "\(mm)/\(yy)"
                                } else {
                                    viewModel.input.expiryDate = trimmed
                                }
                            }

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 1, height: 24)

                        SecureField("key.cvv".localized, text: $viewModel.input.cvv)
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.input.cvv) { newValue in
                                let digitsOnly = newValue.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
                                viewModel.input.cvv = String(digitsOnly.prefix(3))
                            }
                    }
                }

                // SECTION 2: Bank Picker
                Section(header: Text("key.bank".localized)) {
                    Menu {
                        ForEach(BankType.allCases.filter { $0 != .unknown }) { bank in
                            Button(action: {
                                viewModel.input.bankType = bank
                            }) {
                                Label {
                                    Text(bank.rawValue)
                                        .foregroundColor(.primary)
                                } icon: {
                                    Image(bank.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    } label: {
                        bankPickerLabel
                    }
                }
            }
            .navigationBarTitle("key.add_new_card".localized, displayMode: .inline)
            .navigationBarItems(
                leading: Button("key.cancel".localized) {
                    viewModel.onDismissNewCard()
                },
                trailing: Button("key.save".localized) {
                    viewModel.onSaveNewCard()
                }
                .disabled(!viewModel.isFormValid())
                .bold()
            )
        }
    }

    // MARK: - Bank Picker Label
    private var bankPickerLabel: some View {
        HStack {
            if viewModel.input.bankType == .unknown {
                Text("key.select_bank".localized)
                    .foregroundColor(.gray)
            } else {
                Image(viewModel.input.bankType.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)

                Text(viewModel.input.bankType.rawValue)
                    .foregroundColor(.primary)
            }

            Spacer()

            Image(systemName: "chevron.down")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}
