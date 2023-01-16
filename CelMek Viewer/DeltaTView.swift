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


struct DeltaTValue {
  var date: Foundation.Date
  var dt: Double
}

func makeDeltaTPoints() -> [DeltaTValue] {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyy-MM-dd"
  let startDate = formatter.date(from: "1620-01-01")!
  var deltaTValues : [DeltaTValue] = []
  for i in Int64(0)...Int64(6000) {
    deltaTValues.append(
      DeltaTValue(
        date:
          Foundation.Date(
            timeInterval:
              TimeInterval(integerLiteral: i * 3600 * 24 * 30),
            since: startDate),
        dt:
          CelMek.deltaT(year: 1600.0 + Double(i)*30.0 / 365.25)
      )
    )
  }
  return deltaTValues
}


struct DeltaTView: View {
    var body: some View {
      Chart {
        ForEach(makeDeltaTPoints(), id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("DT", item.dt),
                    series: .value("DT", "A")
                )
                .foregroundStyle(.blue)
            }

      }.padding()
    }
}


struct DeltaTView_Previews: PreviewProvider {
    static var previews: some View {
        DeltaTView()
    }
}
