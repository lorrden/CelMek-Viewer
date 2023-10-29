//
// SPDX-License-Identifier: Apache-2.0
//
// Copyright 2023 Mattias Holm
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI
import Charts
import CelMek
import Aerodynamics

struct Point: Identifiable {
  let id: UUID = UUID()
  var xu: Double
  var yu: Double
  var xl: Double
  var yl: Double
  var meanCamberX: Double
  var meanCamberY: Double
}



func computeAirfoil(foil: NACA4) -> [Point] {

  var coords = [Point]()

  for i in 0 ... 100 {
    let meanCamber = foil.meanCamberLine(Double(i) / 100.0)
    let point = foil.surfaceCoord(x: Double(i) / 100.0)
    coords.append(Point(xu: point.0.x,
                        yu: point.0.y,
                        xl: point.1.x,
                        yl: point.1.y,
                        meanCamberX: Double(i)/100.0,
                        meanCamberY: meanCamber))
  }

  return coords
}

struct AirfoilView: View {
  @State private var camber: Int = 2
  @State private var maxCamber: Int = 4
  @State private var maxThickness: Int = 12

  var body: some View {

    HStack{
      VStack {
        Stepper(value: $camber, in: 0...9, step: 1) {
          Text("Camber: \(camber)")
        }
        Stepper(value: $maxCamber, in: 0...9, step: 1) {
          Text("Max Camber: \(maxCamber)")
        }
        Stepper(value: $maxThickness, in: 0...30, step: 1) {
          Text("Max Thickness: \(maxThickness)")
        }
      }
      let foil = NACA4(camberPercentage: camber,
                       maximumCamber: maxCamber,
                       maximumThicknessPercentage: maxThickness)
      let foilCoords = computeAirfoil(foil: foil)

      Chart(foilCoords) {
        LineMark(
          x: .value("x", $0.xu),
          y: .value("y", $0.yu),
          series: .value("xu", "yu")
        ).foregroundStyle(.blue)

        LineMark(
          x: .value("x", $0.xl),
          y: .value("y", $0.yl),
          series: .value("xl", "yl")
        ).foregroundStyle(.blue)

        LineMark(
          x: .value("x", $0.meanCamberX),
          y: .value("y", $0.meanCamberY),
          series: .value("meanCamberX", "meanCamberY")
        ).foregroundStyle(.red)
      }
      .chartXScale(domain: -0.1...1.1)
      .chartYScale(domain: -0.3...0.3)
      .chartXAxisLabel("Chord")
      .chartYAxisLabel("Thickness")
    }
  }
}

//#Preview {
//    AirfoilView()
//}
