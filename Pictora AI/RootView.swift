import SwiftUI

struct RootView: View {
    @State private var selectedTab: TabItem = .home
    @State private var showingProfile = false
    
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
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                }
                ToolbarItem(placement: .principal) {
                    Typography(label: "Pictora AI", variants: .logo, color: .white)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingProfile = true }) {
                        Image("man")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
            }
            .ignoresSafeArea(.all)
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

#Preview {
    RootView()
}
