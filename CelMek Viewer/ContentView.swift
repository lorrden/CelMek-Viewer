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
struct ListItem: Identifiable, Hashable {
  let file: String
  let name: String
  let id = UUID()
}

private var listItems = [
  ListItem(file: "function", name: "DeltaT"),
  ListItem(file: "calendar", name: "Moslem Dates"),
  ListItem(file: "calendar", name: "Jewish Dates"),
  ListItem(file: "calendar", name: "Julian Dates"),
  ListItem(file: "calendar", name: "Gregorian Dates"),
  ListItem(file: "calendar", name: "Current Date"),
  ListItem(file: "function", name: "Mean Obliquity"),
  ListItem(file: "function", name: "Airfoil"),
  ListItem(file: "function", name: "Atmosphere"),
]

struct ContentView: View {
  @State private var selection = listItems[0].id
  var body: some View {
    HSplitView {
      List(listItems, selection: $selection) {
        SourceListRowView(image:
                            Image(systemName: $0.file),
                          name: $0.name)
      }.frame(minWidth: 200, maxWidth: 250, maxHeight: .infinity)

      switch (selection) {
      case listItems[0].id:
        DeltaTView().frame(minWidth: 400,
                           maxWidth: .infinity,
                           minHeight: 400,
                           maxHeight: .infinity).padding()
      case listItems[1].id:
        MoslemDateView().frame(minWidth: 400,
                               maxWidth: .infinity,
                               minHeight: 400,
                               maxHeight: .infinity).padding()
      case listItems[2].id:
        JewishDateView().frame(minWidth: 400,
                               maxWidth: .infinity,
                               minHeight: 400,
                               maxHeight: .infinity).padding()
      case listItems[3].id:
        JulianDateView().frame(minWidth: 400,
                               maxWidth: .infinity,
                               minHeight: 400,
                               maxHeight: .infinity).padding()
      case listItems[4].id:
        GregorianDateView().frame(minWidth: 400,
                                  maxWidth: .infinity,
                                  minHeight: 400,
                                  maxHeight: .infinity).padding()
      case listItems[5].id:
        TimelineView(.periodic(from: Date(), by: 1)) { context in
          CurrentDateView(date: context.date)
            .frame(minWidth: 400,
                   maxWidth: .infinity,
                   minHeight: 400,
                   maxHeight: .infinity).padding()
        }
      case listItems[6].id:
        MeanObliquityView().frame(minWidth: 400,
                                  maxWidth: .infinity,
                                  minHeight: 400,
                                  maxHeight: .infinity).padding()
      case listItems[7].id:
        AirfoilView().frame(minWidth: 400,
                                  maxWidth: .infinity,
                                  minHeight: 400,
                                  maxHeight: .infinity).padding()
      case listItems[8].id:
        AtmosphereView().frame(minWidth: 400,
                               maxWidth: .infinity,
                               minHeight: 400,
                               maxHeight: .infinity).padding()

      default:
        Text("Bad view").frame(minWidth: 400,
                               maxWidth: .infinity,
                               minHeight: 400,
                               maxHeight: .infinity).padding()
      }
    }.frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
