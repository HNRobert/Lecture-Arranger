//
//  TableView.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/10.
//

import SwiftUI


@available(iOS 17.0, *)
struct TableView: View {
    @Binding var LAData: LA_Data
    
    @Binding public var selectedSheetIdx: Int
    @Binding public var isTeacher: Bool
    @Binding public var selectedItemIndex: [Int]
    
    var columnNameList: [String]
        
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack{
                    Spacer(minLength: max((geometry.size.width - CGFloat(columnNameList.count + 1) * 102) / 2, 5)) // Adjust based on content size
                    VStack(spacing: 0) {
                        HStack(spacing: 1.5){
                            Rectangle()
                                .stroke(Color.black, lineWidth: 2)
                                .fill(Color.white)
                                .frame(width: 100, height: 40)
                            ForEach(0..<columnNameList.count, id: \.self) { index in
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .fill(Color.white)
                                    .frame(width: 100, height: 40)
                                    .overlay(
                                        Text(columnNameList[index])
                                            .foregroundColor(.black)
                                    )
                            }
                        }.border(Color.black)
                            .frame(minWidth: CGFloat.zero)
                        ForEach(0..<LAData.amLessonNum+LAData.pmLessonNum, id: \.self) { row in
                            if row == LAData.amLessonNum {
                                Spacer().frame(height: 3)
                            }
                            HStack(spacing: 1.5) {
                                Rectangle()
                                    .stroke(Color.black, lineWidth: 2)
                                    .fill(Color.white)
                                    .frame(width: 100, height: 40)
                                    .overlay(
                                        Text("L\(row+1)")
                                            .foregroundColor(.black)
                                    )
                                
                                ForEach(0..<columnNameList.count, id: \.self) { col in
                                    Rectangle()
                                        .stroke(Color.black, lineWidth: 2)
                                        .fill(Color.white)
                                        .frame(width: 100, height: 40)
                                        .overlay(
                                            Text(isTeacher ? "\(LAData.teacherTimeTable[selectedSheetIdx][row][col])" : "\(LAData.schedule[selectedSheetIdx][row][col])")
                                                .foregroundColor(.black)
                                        )
                                        .onTapGesture {
                                            selectedItemIndex = [row, col]
                                            if isTeacher {
                                                let newValue = LAData.teacherTimeTable[selectedSheetIdx][row][col] != "" ? "" : "Occupied"
                                                LAData.teacherTimeTable[selectedSheetIdx][row][col] = newValue
                                                LAData.teacherBusyStorage[selectedSheetIdx][row][col] = newValue
                                            }
                                            print("Row\(row + 1)，Column\(col + 1)")
                                        }
                                }
                            }.border(Color.black)
                                .frame(alignment: .center)
                        }
                        Spacer().frame(height: 15)
                    }
                }
                Spacer()
            }
        }.frame(height: CGFloat((LAData.amLessonNum + LAData.pmLessonNum) * 40 + 40))
    }
}


