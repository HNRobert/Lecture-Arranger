//
//  GeneralView.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/12.
//

import SwiftUI

struct GeneralSettingView: View {
    @Binding var LAData: LA_Data
    
    @State private var weekDaysOrder: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    @State private var weekDays: [SelectableItem] = [.init(name: "Monday"), .init(name: "Tuesday"), .init(name: "Wednesday"), .init(name: "Thursday"), .init(name: "Friday"), .init(name: "Saturday"), .init(name: "Sunday")]
    @State private var isHelpPresented: Bool = false
    
    var scheduleFrameHeight: CGFloat {
        #if os(macOS)
        return 188
        #else
        return 385
        #endif
    }
    
    var body: some View {
        ScrollView{
            Spacer().frame(height: 20)
            
            Text("Scheduled Days")
                .font(.title)
            List($weekDays, id: \.self) { day in
                HStack {
                    Text(day.wrappedValue.name)
                    Spacer()
                    Toggle("", isOn: self.binding(for: day.wrappedValue))
                        .labelsHidden()
                }
            }.frame(height: scheduleFrameHeight)
            
            Spacer().frame(height: 30)
            
            Text("Lessons' number in a day")
                .font(.title)
            
            HStackLayout{
                Spacer().frame(width: 15)
                Text("Morning")
                Picker(selection: $LAData.amLessonNum, label: Text("")) {
                    ForEach(0..<6) { number in
                        Text("\(number)").tag(number)
                    }
                }
                Spacer().frame(width: 15)
                Text("Afternoon")
                Picker(selection: $LAData.pmLessonNum, label: Text("")) {
                    ForEach(0..<6) { number in
                        Text("\(number)").tag(number)
                    }
                }
                Spacer().frame(width: 16)
            }
        }.navigationTitle("General Settings")
            .sheet(isPresented: $isHelpPresented, content: {
                GeneralSettingHelpView()
            })
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isHelpPresented = true
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                }
            }

    }
    
    private func binding(for item: SelectableItem) -> Binding<Bool> {
        Binding<Bool>(
            get: { LAData.scheduleDays.contains(item.name) },
            set: { isSelected in
                if isSelected {
                    LAData.scheduleDays.append(item.name)
                    LAData.scheduleDays.sort {
                        guard let first = weekDaysOrder.firstIndex(of: $0), let second = weekDaysOrder.firstIndex(of: $1) else {
                            return false
                        }
                        return first < second
                    }
                } else {
                    LAData.scheduleDays.removeAll{ $0 == item.name }
                }
            }
        )
    }
}

