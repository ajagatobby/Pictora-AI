import SwiftUI

// Placeholder views for other tabs
struct AIStoreView: View {
    @State private var isNavigatingToSignatureView: Bool = false
    @State private var isNavigatingTophotoToCartoonView: Bool = false
    @State private var isNavigatingToPhotoToAnimeView: Bool = false
    @State private var isNavigatingToPhotoToStickerView: Bool = false
    @State private var isNavigatingToPhotoRemoverView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                GradientBackground2()
                ScrollView(showsIndicators: false) {
                    HStack {
                        Text("All Tools")
                            .font(.fkDisplay(.regularAlt, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 30)
                    VStack(alignment: .leading, spacing: 4) {
                        Typography(label: "Pictora AI Pro", variants: .display2, color: .white)
                        Typography(label: "Upgrade to the latest AI model and bosst your Pro generation uses", variants: .body2, color: .white)
                        Spacer()
                        CustomButton(label: "Learn more", height: 45, background: .solid(.white), textColor: .black, icon: "arrow.right", position: .trailing)
                    }
                    .frame(width: UIScreen.main.bounds.width - 20, height: 200)
                    .padding(.vertical, 30)
                    .background(
                        ZStack {
                            Image("bg-8")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
                            LinearGradient(
                                colors: [
                                    .black.opacity(0.7),
                                    .black.opacity(0.4)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                    )
                    .cornerRadius(16)
                    
                    VStack(spacing: 15) {
                        // Card
                        AIToolCard(
                            imageName: "remove-bg",
                            title: "Remove background",
                            description: "Remove backgrounds from your images just with a click",
                            accentColor: .blue,
                            onTap: {
                                isNavigatingToPhotoRemoverView = true
                            }
                        )
                        
                        AIToolCard(
                            imageName: "ai-signature",
                            title: "AI Signature",
                            description: "Curate your personalized, signature with easing using AI",
                            accentColor: .blue,
                            onTap: {
                                isNavigatingToSignatureView = true
                            }
                        )
                        
                        AIToolCard(
                            imageName: "photo-to-cartoon",
                            title: "AI Photo To Cartoon",
                            description: "Curate your personalized, signature with easing using AI",
                            accentColor: .blue,
                            onTap: {
                                isNavigatingTophotoToCartoonView = true
                            }
                        )
                        
                        AIToolCard(
                            imageName: "photo-to-anime",
                            title: "AI Photo To Anime",
                            description: "Turn your pictures into anime",
                            accentColor: .blue,
                            onTap: {
                                isNavigatingToPhotoToAnimeView = true
                            }
                        )
                        
                        AIToolCard(
                            imageName: "face-to-sticker",
                            title: "AI Face To Sticker",
                            description: "Create your unique striking sticker with ease.",
                            accentColor: .blue,
                            onTap: {
                                isNavigatingToPhotoToStickerView = true
                            }
                        )
                        
                        
                        
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 200)
                }
                .padding(.horizontal)
            }
        }
        .navigationDestination(isPresented: $isNavigatingToSignatureView){
            AISignatureView().navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $isNavigatingTophotoToCartoonView){
            PhotoToCartoonView().navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $isNavigatingToPhotoToAnimeView){
            PhotoToAnimeView().navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $isNavigatingToPhotoToStickerView){
            FaceToStickerView().navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $isNavigatingToPhotoRemoverView){
            RemoveBackgroundView().navigationBarBackButtonHidden()
        }
    }
}


#Preview {
    AIStoreView()
}
