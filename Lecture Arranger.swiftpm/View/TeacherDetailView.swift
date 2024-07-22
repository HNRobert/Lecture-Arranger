//
//  TeacherDetailView.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/12.
//

import SwiftUI

@available(iOS 17.0, *)
struct TeacherDetailView: View {
    var teacherName: String
    @Binding var LAData: LA_Data
    @State private var selectedTeacherIndex: Int = 0
    @State private var selectedCourseIndex: [Int] = [0,0]
    @State private var isTeacher: Bool = true
    
    @Environment(\.dismiss) var dismiss
    
    var isMac: CGFloat {
        #if os(macOS)
        return 1
        #else
        return 0
        #endif
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 10)
                HStack{
                    Spacer().frame(width: 15)
                    Button(action: { dismiss() }) {
                        Label("Back ", systemImage: "chevron.backward")
                    } .buttonStyle(.borderless)
                    Spacer()
                }
                Spacer().frame(width: isMac * CGFloat(LAData.scheduleDays.count * 102 + 160), height: 10)
                Text("Time Table for \(teacherName)")
                    .font(.title)
                HStack{
                    Spacer()
                    TableView(LAData: $LAData, selectedSheetIdx: $selectedTeacherIndex, isTeacher: $isTeacher, selectedItemIndex: $selectedCourseIndex, columnNameList: LAData.scheduleDays)
                        .onAppear{selectedTeacherIndex = LAData.teacherList.firstIndex(of: teacherName) ?? 0}
                        .padding()
                    Spacer()
                }
            }
        }.navigationTitle("Teacher Setting")
    }
}
