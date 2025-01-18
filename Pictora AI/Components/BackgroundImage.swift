import SwiftUI

struct BackgroundImageView: View {
    let imageName: String
    let geometry: GeometryProxy
    
    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
    }
}
