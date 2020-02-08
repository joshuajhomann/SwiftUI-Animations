//
//  ContentView.swift
//  Animated-Spirograph-SwiftUI
//
//  Created by Joshua Homann on 2/1/20.
//  Copyright © 2020 com.josh. All rights reserved.
//

import SwiftUI

enum Constant {
  static let maxMajorRadius: CGFloat = 100
  static let maxMinorRadius: CGFloat = 100
  static let maxOffset: CGFloat = 50
  static let maxSamples: CGFloat = 100
  static let iterations = 2000
}

struct SpirographView: AnimatableModifier {
  var color: UIColor
  var majorRadius: CGFloat
  var minorRadius: CGFloat
  var offset: CGFloat
  var samples: CGFloat

  var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>,AnimatablePair<CGFloat, CGFloat>> {
    get {
      .init(.init(majorRadius, minorRadius), .init(offset, samples))
    }
    set {
      majorRadius = newValue.first.first
      minorRadius = newValue.first.second
      offset = newValue.second.first
      samples = newValue.second.second
    }
  }

  func body(content: Content) -> some View {
    let Δr = majorRadius - minorRadius
    let Δθ = 2 * CGFloat.pi / samples
    let points = (0..<Constant.iterations).map { iteration -> CGPoint in
      let θ = Δθ * CGFloat(iteration)
      return .init(
        x: CGFloat(Δr * cos(θ) + offset  * cos(Δr * θ / minorRadius )),
        y: CGFloat(Δr * sin(θ) + offset  * sin(Δr * θ / minorRadius ))
      )
    }
    return GeometryReader { geometry in
      Path { path in
        path.addLines(points)
      }
      .applying( {
        let rect = geometry.frame(in: .local)
        let scale = min(
          rect.width / (Constant.maxMajorRadius * 2),
          rect.height / (Constant.maxMajorRadius * 2)
        )
        return CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2)
          .scaledBy(x: scale, y: scale)
        }()
      )
      .strokedPath(.init(lineWidth: 1))
      .foregroundColor(Color(self.color))
      .clipped()
    }
  }
}

struct ContentView: View {
  @State var sliderMajorRadius = Constant.maxMajorRadius
  @State var sliderMinorRadius = Constant.maxMinorRadius / 2
  @State var sliderOffset = Constant.maxOffset / 2
  @State var sliderSamples = Constant.maxSamples / 2

  @State var majorRadius = Constant.maxMajorRadius
  @State var minorRadius = Constant.maxMinorRadius / 2
  @State var offset = Constant.maxOffset / 2
  @State var samples = Constant.maxSamples / 2

  var body: some View {
    VStack {
      ZStack {
        Color.clear
        Color.clear.modifier(
          SpirographView(
            color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
            majorRadius: sliderMajorRadius,
            minorRadius: sliderMinorRadius,
            offset: sliderOffset,
            samples: sliderSamples
          )
        )
        Color.clear.modifier(
          SpirographView(
            color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1),
            majorRadius: majorRadius,
            minorRadius: minorRadius,
            offset: offset,
            samples: samples
          )
        )
      }
      VStack {
        sliderView(name: "Major", min: 0, max: Constant.maxMajorRadius, binding: $sliderMajorRadius)
        sliderView(name: "Minor", min: 0, max: Constant.maxMinorRadius, binding: $sliderMinorRadius)
        sliderView(name: "Offset", min: 0, max: Constant.maxOffset, binding: $sliderOffset)
        sliderView(name: "Sample", min: 2, max: Constant.maxSamples, binding: $sliderSamples)
        Button("Animate") {
          withAnimation(.easeInOut(duration: 5)) {
            self.majorRadius = self.sliderMajorRadius
            self.minorRadius = self.sliderMinorRadius
            self.offset = self.sliderOffset
            self.samples = self.sliderSamples
          }
        }
      }.padding()
    }
  }

  private func sliderView(name: String, min: CGFloat, max: CGFloat, binding: Binding<CGFloat>) -> some View {
    HStack {
      Text(name)
        .font(.caption)
        .frame(width: 50)
      Slider(value: binding, in: (min...max))
      Text("\(Int(binding.wrappedValue))").frame(width: 40)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
