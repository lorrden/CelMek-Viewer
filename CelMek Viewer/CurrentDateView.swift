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


import Foundation
import SwiftUI
import CelMek


struct CurrentDateView: View {
  @State private var date = Date()
  let calendar = Calendar(identifier: .gregorian)

  var year : Int  {
    get {
      return calendar.dateComponents([.year], from: date).year!
    }
  }
  var month : CelMek.Month  {
    get {
      return CelMek.Month(
        rawValue:
          Int32(calendar.dateComponents([.month], from: date).month!))!
    }
  }
  var day : Int {
    get {
      return calendar.dateComponents([.day], from: date).day!
    }
  }
  var timeOfDay: Double {
    let components = calendar.dateComponents(in: .gmt, from: date)
    let hour = Double(components.hour!)
    let minute = Double(components.minute!)
    let second = Double(components.second!)
    let nanosecond = Double(components.nanosecond!)
    return hour / 24.0 + minute / 60.0 / 24.0 + second / 60.0 / 60.0 / 24.0 + nanosecond / 1000000000.0 / 60.0 / 60.0 / 24.0
  }
  var moslemDate : MoslemDate {
    get {
      return MoslemDate(julianDate: julianDate)
    }
  }
  var julianDate : JulianDate {
    get {
      return gregorianDate.toJD().toJulian()
    }
  }
  var gregorianDate : GregorianDate {
    get {
      return GregorianDate(year: year, month: month, day: Double(day) + timeOfDay)
    }
  }
  var body: some View {
    VStack {
      Text("JD: \(gregorianDate.toJD())")
      Text("MJD: \(gregorianDate.toJD().asMJD)")
      Text("Gregorian: \(gregorianDate.description)")
      Text("Julian: \(julianDate.description)")
      Text("Moslem: \(moslemDate.description)")
    }.padding()
  }
}

struct CurrentDateView_Previews: PreviewProvider {
  static var previews: some View {
    CurrentDateView()
  }
}
