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
  private var date: Foundation.Date
  init(date: Foundation.Date) {
    self.date = date
  }
  let calendar = Calendar(identifier: .gregorian)

  var year : Int  {
    get {
      let components = calendar.dateComponents(in: .gmt, from: date)
      return components.year!
    }
  }
  var localYear : Int  {
    get {
      let components = calendar.dateComponents(in: .current, from: date)
      return components.year!
    }
  }
  var month : CelMek.Month  {
    get {
      let components = calendar.dateComponents(in: .gmt, from: date)
      return CelMek.Month(
        rawValue:
          Int32(components.month!))!
    }
  }
  var localMonth : CelMek.Month  {
    get {
      let components = calendar.dateComponents(in: .current, from: date)
      return CelMek.Month(
        rawValue:
          Int32(components.month!))!
    }
  }
  var day : Int {
    get {
      let components = calendar.dateComponents(in: .gmt, from: date)
      return components.day!
    }
  }
  var localDay : Int {
    get {
      let components = calendar.dateComponents(in: .current, from: date)
      return components.day!
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

  var localTimeOfDay: Double {
    let components = calendar.dateComponents(in: .current, from: date)
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
  var localMoslemDate : MoslemDate {
    get {
      return MoslemDate(julianDate: localJulianDate)
    }
  }
  var julianDate : JulianDate {
    get {
      return gregorianDate.toJD().toJulian()
    }
  }
  var localJulianDate : JulianDate {
    get {
      return localGregorianDate.toJD().toJulian()
    }
  }
  var gregorianDate : GregorianDate {
    get {
      return GregorianDate(year: year, month: month, day: Double(day) + timeOfDay)
    }
  }
  var localGregorianDate : GregorianDate {
    get {
      return GregorianDate(year: localYear, month: localMonth, day: Double(localDay) + localTimeOfDay)
    }
  }

  var body: some View {
    HStack {
      GroupBox(label: Label("UTC", systemImage: "calendar.badge.clock")) {
        List {
          LabeledContent("JD") {
            Text("\(gregorianDate.toJD())")
          }
          LabeledContent("MJD") {
            Text("\(gregorianDate.toJD().asMJD)")
          }
          LabeledContent("Gregorian") {
            Text("\(gregorianDate.description)")
          }
          LabeledContent("Julian") {
            Text("\(julianDate.description)")
          }
          LabeledContent("Moslem") {
            Text("\(moslemDate.description)")
          }
        }
      }

      GroupBox(label: Label("Local", systemImage: "calendar.badge.clock")) {
        List {
          LabeledContent("MJD") {
            Text("\(localGregorianDate.toJD().asMJD)")
          }
          LabeledContent("Gregorian") {
            Text("\(localGregorianDate.description)")
          }
          LabeledContent("Julian") {
            Text("\(localJulianDate.description)")
          }
          LabeledContent("Moslem") {
            Text("\(localMoslemDate.description)")
          }
        }
      }
    }
  }
}


struct CurrentDateView_Previews: PreviewProvider {
  static var previews: some View {
    CurrentDateView(date: Date())
  }
}
