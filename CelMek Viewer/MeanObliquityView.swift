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


struct Obliquity : Identifiable {
  let id: UUID = UUID()
  var centuries: Double
  var e0: Double
}

fileprivate func makePoints() -> [[Obliquity]] {
  let startDate = -110
  var fastObliquityValues : [Obliquity] = []
  var accurateObliquityValues : [Obliquity] = []
  for i in 0...220 {
    let century = Double(startDate) + Double(i)
    let fastE0 = CelMek.fastMeanObliquityOfTheEcliptic(
      jd: JulianDate(year: -9000 + i * 100,
                     month: .January,
                     day: 1).toJD()).asDeg
    let accurateE0 = CelMek.meanObliquityOfTheEcliptic(
      jd: JulianDate(year: -9000 + i * 100,
                     month: .January,
                     day: 1).toJD()).asDeg
    fastObliquityValues.append(
      Obliquity(centuries: century,
                e0: fastE0))
    accurateObliquityValues.append(
      Obliquity(centuries: century,
                e0: accurateE0))
  }
  return [fastObliquityValues, accurateObliquityValues]
}

struct MeanObliquityView: View {
  var body: some View {
    VStack {
      let points = makePoints()
      GroupBox(label: Label("Fast Method", systemImage: "function")) {
        Chart(points[0]) {
          LineMark(
            x: .value("Centuries", $0.centuries),
            y: .value("𝜀₀", $0.e0)
          ).foregroundStyle(.blue)
        }
        .chartXScale(domain: -115...115)
        .chartYScale(domain: 22...25)
        .chartXAxisLabel("Centuries since the year 2000")
        .chartYAxisLabel("𝜀₀")
      }
      GroupBox(label: Label("Accurate Method", systemImage: "function")) {
        Chart(points[1]) {
          LineMark(
            x: .value("Centuries", $0.centuries),
            y: .value("𝜀₀", $0.e0)
          )
        }.foregroundStyle(.red)
        .chartXScale(domain: -115...115)
        .chartYScale(domain: 22...25)
        .chartXAxisLabel("Centuries since the year 2000")
        .chartYAxisLabel("𝜀₀")
      }
    }
  }
}

struct MeanObliquityView_Previews: PreviewProvider {
  static var previews: some View {
    MeanObliquityView()
  }
}
