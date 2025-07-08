import SwiftUI

struct CardListItemView: View {
    let cardItem: CardItemModel
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 8) {
                        Image(cardItem.bankType.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(cardItem.bankType.rawValue)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                    Text("**** \(cardItem.cardNumber.suffix(4))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

//                HStack {
//                    Text(cardItem.cardHolderName)
//                        .font(.callout)
//                        .foregroundColor(.primary)
//                    Spacer()
//                }

                HStack {
                    Text("$\(String(format: "%.2f", cardItem.balance))")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(cardItem.cardType.logoAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.05), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
