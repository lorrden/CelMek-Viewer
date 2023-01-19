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

struct JewishDateView: View {
  @State private var date = Date()
  let calendar = Calendar(identifier: .hebrew)
  var year : Int  {
    get {
      return calendar.dateComponents([.year], from: date).year!
    }
  }
  var month : CelMek.JewishMonth  {
    get {
      return CelMek.JewishMonth(
        rawValue:
          Int32(calendar.dateComponents([.month], from: date).month!))!
    }
  }
  var day : Int {
    get {
      return calendar.dateComponents([.day], from: date).day!
    }
  }

  
  var body: some View {
    HStack{
      GroupBox(label: Label("Jewish Date", systemImage: "calendar.badge.clock")) {
        DatePicker("Date", selection: $date,
                   displayedComponents: [.date])
        .datePickerStyle(.graphical)
        .environment(\.calendar, calendar)
      }
      
      Text("Selected: \(year)-\(month.rawValue)-\(day)")
    }
  }
}


struct JewishDateView_Previews: PreviewProvider {
  static var previews: some View {
    JewishDateView()
  }
}
