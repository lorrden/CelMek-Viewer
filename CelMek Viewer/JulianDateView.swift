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

struct IdentifiableJulianDate: Identifiable {
  var date: JulianDate
  let id = UUID()
  
  var year: String {
    String(date.year)
  }
  var month: String {
    String(date.month.description)
  }
  var day: String {
    String(Int(date.day))
  }
}

func getJulianEasterDates() -> [IdentifiableJulianDate] {
  var easters = [IdentifiableJulianDate]()
  for i in 1000 ... 2500 {
    easters.append(IdentifiableJulianDate(date: julianDateOfEaster(year: i)))
  }
  return easters
}

func currentJulianDate() -> Foundation.Date
{
  let calendar = Calendar(identifier: .gregorian)
  let currentDate = Date()
  let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
  let gregorianDate = GregorianDate(year: components.year!,
                               month: Month(rawValue: Int32(components.month!))!,
                               day: Double(components.day!))
  let julianDate = gregorianDate.toJD().toJulian()
  
  var julianComponents = DateComponents()
  julianComponents.calendar = calendar
  julianComponents.year = julianDate.year
  julianComponents.month = Int(julianDate.month.rawValue)
  julianComponents.day = Int(julianDate.day)
  return julianComponents.date!
}

struct JulianDateView: View {
  @State private var date = currentJulianDate()
  
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
  var moslemDate : MoslemDate {
    get {
      return MoslemDate(julianDate: julianDate)
    }
  }
  var julianDate : JulianDate {
    get {
      return JulianDate(year: year, month: month, day: Double(day))
    }
  }
  var gregorianDate : GregorianDate {
    get {
      return julianDate.toJD().toGregorian()
    }
  }
  var body: some View {
    VStack {
      GroupBox(label: Label("Julian Date", systemImage: "calendar.badge.clock")) {
        HStack{
          DatePicker("Date", selection: $date,
                     displayedComponents: [.date])
          .datePickerStyle(.graphical)
          .environment(\.calendar, calendar)
          
          VStack {
            Text("Julian: \(julianDate.description)")
            Text("Gregorian: \(gregorianDate.description)")
            Text("Moslem: \(moslemDate.description)")
            Text("JD: \(julianDate.toJD())")
            Text("MJD: \(julianDate.toJD().asMJD)")
          }
        }
      }
      GroupBox(label: Label("Julian Easter", systemImage: "calendar.badge.clock")) {
        Table(getJulianEasterDates()) {
          TableColumn("Year", value: \.year)
          TableColumn("Month", value: \.month)
          TableColumn("Day", value: \.day)
        }
      }
    }
  }
}

struct JulianDateView_Previews: PreviewProvider {
  static var previews: some View {
    JulianDateView()
  }
}
