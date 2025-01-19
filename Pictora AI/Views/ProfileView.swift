import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image("man")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2)
                            )
                        
                        Text("John Doe")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("Free Plan")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Premium Banner
                    ZStack {
                        // Background Image
                        Image("bg-5")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(
                                        colors: [
                                            Color.black.opacity(0.3),
                                            Color.black.opacity(0.5)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                            )
                        
                        // Content
                        VStack(spacing: 12) {
                            Text("Upgrade to Premium")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Unlock unlimited AI art generation")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Button(action: {
                                // Handle upgrade action
                            }) {
                                Text("Upgrade Now")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick Actions
                    HStack(spacing: 20) {
                        ActionButton(icon: "star.fill", title: "Rate", action: {
                            if let url = URL(string: "itms-apps://apple.com/app/idYOUR_APP_ID") {
                                openURL(url)
                            }
                        })
                        
                        ActionButton(icon: "square.and.arrow.up", title: "Share", action: shareApp)
                        
                        ActionButton(icon: "envelope.fill", title: "Support", action: {
                            if let url = URL(string: "mailto:support@pictoraai.app") {
                                openURL(url)
                            }
                        })
                    }
                    .padding(.horizontal)
                    
                    // Menu Items
                    VStack(spacing: 0) {
                        // Privacy Policy Link
                        WebLink(
                            icon: "lock.shield.fill",
                            title: "Privacy Policy",
                            url: "https://pictoraai.app/privacy"
                        )
                        
                        Divider()
                            .padding(.leading, 56)
                        
                        // Terms of Service Link
                        WebLink(
                            icon: "doc.text.fill",
                            title: "Terms of Service",
                            url: "https://pictoraai.app/terms"
                        )
                        
                        Divider()
                            .padding(.leading, 56)
                        
                        MenuLink(icon: "gear", title: "Privacy Settings", destination: AnyView(PrivacySettingsView()))
                        
                        Divider()
                            .padding(.leading, 56)
                        
                        // Restore Purchases
                        Button(action: {
                            // Handle restore purchases
                        }) {
                            MenuRow(icon: "arrow.clockwise", title: "Restore Purchases")
                        }
                        
                        Divider()
                            .padding(.leading, 56)
                        
                        // Logout
                        Button(action: {
                            // Handle logout
                        }) {
                            MenuRow(icon: "rectangle.portrait.and.arrow.right", title: "Logout")
                                .foregroundColor(.red)
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
            }
            .background(Color(UIColor.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
    
    private func shareApp() {
        let text = "Create amazing AI art with Pictora AI ✨\nDownload now: https://pictoraai.app"
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            var currentController = rootViewController
            while let presented = currentController.presentedViewController {
                currentController = presented
            }
            
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = currentController.view
                popover.sourceRect = CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            currentController.present(activityVC, animated: true)
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Circle()
                    .fill(LinearGradient(colors: [Color(UIColor.systemGray5), Color(UIColor.systemGray6)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(.primary)
                    )
                
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
            }
        }
    }
}

struct WebLink: View {
    let icon: String
    let title: String
    let url: String
    @Environment(\.openURL) var openURL
    
    var body: some View {
        Button {
            if let url = URL(string: url) {
                openURL(url)
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MenuLink<Destination: View>: View {
    let icon: String
    let title: String
    let destination: Destination
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MenuRow: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16))
            
            Spacer()
        }
        .padding()
    }
}

struct PrivacySettingsView: View {
    @State private var analyticsEnabled = true
    @State private var adsEnabled = true
    @State private var usageDataEnabled = true
    
    var body: some View {
        List {
            Section {
                Toggle("Analytics", isOn: $analyticsEnabled)
                Toggle("Personalized Ads", isOn: $adsEnabled)
                Toggle("Usage Data", isOn: $usageDataEnabled)
            } footer: {
                Text("These settings help us improve your experience and provide relevant content.")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Privacy Settings")
    }
}

#Preview {
    ProfileView()
}
