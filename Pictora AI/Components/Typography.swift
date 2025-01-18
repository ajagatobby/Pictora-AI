import SwiftUI

enum FontType: String {
    case regular = "Regular"
    case regularAlt = "RegularAlt"
    
    var fkDisplay: FkDisplay {
        switch self {
        case .regular:
            return .regular
        case .regularAlt:
            return .regularAlt
        }
    }
}

enum Variants: String {
    case header
    case subHeader
    case display1
    case display2
    case body1
    case body2
    case body3
    case logo
}

struct Typography: View {
    var label: String
    var variants: Variants = .body3
    var color: Color?
    
    private var fontConfiguration: (font: FontType, size: CGFloat) {
        switch variants {
        case .header:
            return (.regular, 50)
        case .subHeader:
            return (.regular, 40)
        case .display1:
            return (.regular, 32)
        case .logo:
            return (.regular, 26)
        case .display2:
            return (.regularAlt, 24)
        case .body1:
            return (.regularAlt, 16)
        case .body2:
            return (.regularAlt, 14)
        case .body3:
            return (.regularAlt, 12)
        }
    }
    
    var body: some View {
        Text(label)
            .font(.fkDisplay(fontConfiguration.font.fkDisplay, size: fontConfiguration.size))
            .foregroundColor(color ?? .black)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 16) {
        Typography(label: "Header Text", variants: .header)
        Typography(label: "Sub Header Text", variants: .subHeader)
        Typography(label: "Display Text 1", variants: .display1)
        Typography(label: "Display Text 2", variants: .display2)
        Typography(label: "Body 1 Text", variants: .body1)
        Typography(label: "Body 2 Text", variants: .body2)
        Typography(label: "Body 3 Text", variants: .body3)
    }
    .padding()
}
