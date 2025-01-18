import SwiftUI


public enum FkDisplay: String, CaseIterable {
    case regularAlt = "FKDisplayTrial-RegularAlt"
    case regular = "FKDisplayTrial-Regular"
    
}


extension Font {
    public static func fkDisplay(_ fk: FkDisplay, size: CGFloat) -> Font {
        return .custom(fk.rawValue, size: size, relativeTo: .body)
    }
}
