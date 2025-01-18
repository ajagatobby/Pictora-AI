import SwiftUI

struct RootView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Color.white.ignoresSafeArea()
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tag(TabItem.home)
                    
                    AIStoreView()
                        .tag(TabItem.store)
                    
                    MyArtsView()
                        .tag(TabItem.arts)
                    
                    DiscoverView()
                        .tag(TabItem.discover)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Typography(label: "Pictora AI", variants: .logo, color: .white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image("man")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
            .ignoresSafeArea(.all)
        }
        .preferredColorScheme(.dark)
    }
}


struct MyArtsView: View {
    var body: some View {
        ZStack {
            GradientBackground()
            Text("My Arts")
                .foregroundColor(.white)
        }
    }
}

struct DiscoverView: View {
    var body: some View {
        ZStack {
            GradientBackground()
            Text("Discover")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    RootView()
}
