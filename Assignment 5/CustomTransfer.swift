import SwiftUI
import UniformTypeIdentifiers

// iOS 14 compatible struct (Transferable protocol requires iOS 16+)
struct CustomTransfer {
    var image: UIImage?
    var text: String?
}
