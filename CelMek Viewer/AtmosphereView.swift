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

struct AtmospherePoint: Identifiable {
  let id: UUID = UUID()
  var elevation: Double
  var temperature: Double
  var pressure: Double
  var density: Double
  var dynamicViscosity: Double
}

func computeAtmosphere(atmosphere: Atmosphere) -> [AtmospherePoint] {

  var coords = [AtmospherePoint]()

  for i in 0 ... 500 {
    let temp = atmosphere.temperature(at: Double(i) * 100.0)
    let pressure = atmosphere.pressure(at: Double(i) * 100.0)
    let density = atmosphere.density(at: Double(i) * 100.0)
    let dynViscosity = atmosphere.dynamicViscosity(at: Double(i) * 100.0)
    coords.append(AtmospherePoint(elevation: Double(i) * 100.0,
                                  temperature: temp,
                                  pressure: pressure,
                                  density: density,
                                  dynamicViscosity: dynViscosity))
  }

  return coords
}

struct AtmosphereView: View {

  var body: some View {

    let atm = EarthAtmosphere()
    let atmCoords = computeAtmosphere(atmosphere: atm)
    HStack {
      Chart(atmCoords) {
        LineMark(
          x: .value("temperature", $0.temperature),
          y: .value("elevation", $0.elevation),
          series: .value("temperature", "elevation")
        ).foregroundStyle(.blue)

      }
      //.chartXScale(domain: -200...200)
      .chartYScale(domain: 0...50000)
      .chartYAxisLabel("Elevation (m)")
      .chartXAxisLabel("Temperature (℃)")

      Chart(atmCoords) {
        LineMark(
          x: .value("pressure", $0.pressure),
          y: .value("elevation", $0.elevation),
          series: .value("pressure", "elevation")
        ).foregroundStyle(.red)
      }
      //.chartXScale(domain: -200...200)
      .chartYScale(domain: 0...50000)
      .chartYAxisLabel("Elevation (m)")
      .chartXAxisLabel("Pressure (kPa)")

      Chart(atmCoords) {
        LineMark(
          x: .value("density", $0.density),
          y: .value("elevation", $0.elevation),
          series: .value("density", "elevation")
        ).foregroundStyle(.green)
      }
      //.chartXScale(domain: -200...200)
      .chartYScale(domain: 0...50000)
      .chartYAxisLabel("Elevation (m)")
      .chartXAxisLabel("Density (kg/㎥)")

      Chart(atmCoords) {
        LineMark(
          x: .value("dynamicViscosity", $0.dynamicViscosity),
          y: .value("elevation", $0.elevation),
          series: .value("viscosity", "elevation")
        ).foregroundStyle(.yellow)
      }
      //.chartXScale(domain: -200...200)
      .chartYScale(domain: 0...50000)
      .chartYAxisLabel("Elevation (m)")
      .chartXAxisLabel("Dynamic Viscosity ((10⁻⁵ N s/m²))")
    }
  }
}

//#Preview {
//    AirfoilView()
//}
