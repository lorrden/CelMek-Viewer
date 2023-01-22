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

struct IdentifiableGregorianDate: Identifiable {
  var date: GregorianDate
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
func getGregorianEasterDates() -> [IdentifiableGregorianDate] {
  var easters = [IdentifiableGregorianDate]()
  for i in 1583 ... 2500 {
    easters.append(IdentifiableGregorianDate(date: gregorianDateOfEaster(year: i)))
  }
  return easters
}

struct GregorianDateView: View {
  @State private var date = Date()
  private let easterRows = getGregorianEasterDates()
  @State private var tableSelection = Set<IdentifiableGregorianDate.ID>()
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
      return gregorianDate.toJD().toJulian()
    }
  }
  var gregorianDate : GregorianDate {
    get {
      return GregorianDate(year: year, month: month, day: Double(day))
    }
  }
  var body: some View {
    VStack {
      GroupBox(label: Label("Gregorian Date", systemImage: "calendar.badge.clock")) {
        HStack{
          DatePicker("Date", selection: $date,
                     displayedComponents: [.date])
          .datePickerStyle(.graphical)
          .environment(\.calendar, calendar)

          List {
            LabeledContent("Gregorian") {
              Text("\(gregorianDate.description)")
            }
            LabeledContent("Julian") {
              Text("\(julianDate.description)")
            }
            LabeledContent("Moslem") {
              Text("\(moslemDate.description)")
            }
            LabeledContent("JD") {
              Text("\(julianDate.toJD())")
            }
            LabeledContent("MJD") {
              Text("\(julianDate.toJD().asMJD)")
            }
          }
        }
      }

      GroupBox(label: Label("Gregorian Easter", systemImage: "calendar.badge.clock")) {
        Table(easterRows, selection: $tableSelection) {
          TableColumn("Year", value: \.year)
          TableColumn("Month", value: \.month)
          TableColumn("Day", value: \.day)
        }
        .focusable()
        .onCopyCommand {
          var items = [NSItemProvider]()
          let selectedItems = easterRows.filter { item in
            return tableSelection.contains(item.id)
          }

          for item in selectedItems {
            items.append(NSItemProvider(object: "\(item.date)" as NSString))
          }

          return items
        }
      }
    }
  }
}
struct GregorianDateView_Previews: PreviewProvider {
  static var previews: some View {
    GregorianDateView()
  }
}
