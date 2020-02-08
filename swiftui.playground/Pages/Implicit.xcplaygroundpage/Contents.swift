import SwiftUI
import PlaygroundSupport


struct ContentView: View {
  @State private var isAnimated = false
  var body: some View {
    VStack {
      (isAnimated ? Color.red : Color.blue)
        .frame(width: 90, height: 90)
        .clipShape(Circle())
        .animation(.default)
      Button("animate") {
        self.isAnimated.toggle()
      }
    }
  }
}

let hostingController = UIHostingController(rootView: ContentView())
PlaygroundPage.current.setLiveView(hostingController)
