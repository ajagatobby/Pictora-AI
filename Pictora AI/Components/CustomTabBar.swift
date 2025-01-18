import SwiftUI

enum TabItem: String, CaseIterable {
    case home = "Home"
    case store = "AI Store"
    case arts = "My Arts"
    case discover = "Discover"
    
    var icon: String {
        switch self {
        case .home:
            return "house.fill"
        case .store:
            return "sparkles.rectangle.stack"
        case .arts:
            return "photo.stack.fill"
        case .discover:
            return "safari.fill"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        HStack {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Spacer()
                TabButton(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = tab
                            HapticManager.shared.trigger(.light)
                        }
                    }
                )
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.4))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.2),
                                    .clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.5
                        )
                )
        )
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

struct TabButton: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tab.icon)
                    .font(.system(size: 20))
                Text(tab.rawValue)
                    .font(.fkDisplay(.regular, size: 12))
            }
            .foregroundStyle(
                isSelected ?
                LinearGradient(
                    colors: [.purple.opacity(0.8), .blue.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) :
                LinearGradient(
                    colors: [.gray.opacity(0.8), .gray.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CustomTabBar(selectedTab: .constant(.home))
    }
}
