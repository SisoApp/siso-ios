import SwiftUI
import auth

public struct ContentView: View {
    public init() {}

    public var body: some View {
        SocialView()
        Text("폰트테스트")
            .font(.appFont(name: .regular, size: 17))
    }
}


 
#Preview {
    ContentView()
}
