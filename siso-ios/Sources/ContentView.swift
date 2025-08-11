import SwiftUI
import auth

public struct ContentView: View {
    public init() {}

    public var body: some View {
        Text("Hello, World!")
            .padding()
            .onAppear() {
                sayHello()
            }
    }
}


 
