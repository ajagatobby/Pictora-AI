import SwiftUI
import CoreData


struct ContentView: View {
    @State private var gradientStart = UnitPoint(x: 0, y: 0)
    @State private var gradientEnd = UnitPoint(x: 1, y: 1)
    @State private var currentImageIndex = 0
    @State private var nextImageIndex = 1
    @State private var fadeOutOpacity = 1.0
    @State private var isNavigatingToRootView = false
    
    let bgs = ["bg-6",  "bg-5", "bg-1", "bg-2", "bg-3", "bg-4", "bg-8", "bg-9"]
    let transitionDuration: Double = 5.0
    let crossFadeDuration: Double = 1.5
    
    // Animation states
    @State private var isAnimating = false
    @StateObject private var particleSystem = ParticleSystem(particles: 100)
    
    // Timer for background transitions
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                ZStack {
                    // Background Stack
                    ZStack {
                        // Next background (bottom layer)
                        BackgroundImageView(imageName: bgs[nextImageIndex], geometry: geometry)
                        
                        // Current background (top layer that fades out)
                        BackgroundImageView(imageName: bgs[currentImageIndex], geometry: geometry)
                            .opacity(fadeOutOpacity)
                    }
                    
                    backgroundOverlay
                    
                    ParticleView(system: particleSystem)
                        .opacity(0.6)
                        .blendMode(.screen)
                    
                    // Content
                    VStack {
                        Spacer()
                        
                        Typography(label: "Pictora AI", variants: .header, color: .white)
                            .shadow(color: .white.opacity(0.6), radius: isAnimating ? 10 : 5)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true),
                                       value: isAnimating)
                        
                        Spacer()
                        
                        CustomButton(label: "Continue with Apple", showAppleIcon: true, background: .solid(.white), textColor: .black, onClick: {
                            isNavigatingToRootView = true
                        })
                        
                        
                        // Enhanced links
                        HStack(spacing: 20) {
                            ForEach(["Privacy Policy", "Terms Of Service"], id: \.self) { text in
                                Typography(label: text, variants: .body3, color: .white)
                                    .opacity(0.8)
                                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                            }
                        }
                        .padding(.vertical)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                isAnimating = true
                particleSystem.start()
            }
            .onReceive(timer) { _ in
                performTransition()
            }
            .navigationDestination(isPresented: $isNavigatingToRootView){
                RootView().navigationBarBackButtonHidden()
            }
        }
        
    }
    private var backgroundOverlay: some View {
        ZStack {
            // Dynamic gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.7),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.6)
                ]),
                startPoint: gradientStart,
                endPoint: gradientEnd
            )
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.clear,
                    Color.black.opacity(0.4)
                ]),
                center: .center,
                startRadius: 150,
                endRadius: 400
            )
        }
    }
    
    
    private func performTransition() {
        withAnimation(.easeInOut(duration: crossFadeDuration)) {
            fadeOutOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + crossFadeDuration) {
            currentImageIndex = nextImageIndex
            nextImageIndex = (nextImageIndex + 1) % bgs.count
            fadeOutOpacity = 1
        }
    }
    
}



#Preview {
    ContentView()
}
