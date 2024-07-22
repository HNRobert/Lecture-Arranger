import SwiftUI

struct ClassSettingView: View {
    @Binding var LAData: LA_Data
    
    @State private var selectedClassIndex: Int = 0
    @State private var isHelpPresented: Bool = false
        
    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            HStack{
                Spacer().frame(width: 55)
                Text("   Number\n of Classes").font(.title2)
                Spacer().frame(width: 45)
                Picker(selection: Binding(
                    get: { LAData.classNum },
                            set: { newValue in
                                LAData.classNum = newValue
                                self.changeClassNum(newNum: newValue)
                            }
                        ), label: Text("")) {
                            ForEach(1..<21) { number in
                                Text("\(number)").tag(number)
                            }
                        }
                Spacer().frame(width: 50)
            }
            
            Spacer().frame(height: 30)
            
            Text("Teachers Setting")
                .font(.title)
            HStack{
                Spacer().frame(width: 15)
                Picker("", selection: $selectedClassIndex) {
                    ForEach(0..<LAData.classNum, id: \.self) { index in
                        Text("Class  \(index + 1)")
                    }
                }.pickerStyle(.segmented)
                Spacer().frame(width: 16)
            }
                        
            Spacer().frame(height: 15)
            
            List{
                ForEach(LAData.lectureList.filter{ LAData.lectureCategory[$0] == 0 }, id: \.self) { lecture in
                    HStack {
                        //Spacer().frame(width: 5)
                        Text(lecture).frame(width: 140, alignment: .leading)

                        Spacer()
                                                
                        if LAData.lecTeacherInfo[lecture]?.isEmpty ?? true {
                            Text("Teacher Unavailable").font(.footnote)
                        } else {
                            teacherPicker(for: lecture)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }
            Spacer()
        }.navigationTitle("Class Information")
            .sheet(isPresented: $isHelpPresented, content: {
                ClassSettingHelpView()
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
    
    private func teacherPicker(for lecture: String) -> some View {
        Picker("", selection: Binding(
            get: {
                let teachers = LAData.lecTeacherInfo[lecture, default: [""]]
                return teachers.firstIndex(of: LAData.classInfo[selectedClassIndex][lecture, default: ""]) ?? 0
            },
            set: { newValue in
                LAData.classInfo[selectedClassIndex][lecture] = LAData.lecTeacherInfo[lecture, default: []][newValue]
            }
        )) {
            ForEach(LAData.lecTeacherInfo[lecture, default: []].indices, id: \.self) { teacherIndex in
                Text(LAData.lecTeacherInfo[lecture, default: []][teacherIndex])
            }
        }
        .frame(alignment: .trailing)
    }
    
    private func changeClassNum(newNum:Int) {
        let numberOfClassesToAdd = newNum - LAData.classInfo.count
        if numberOfClassesToAdd > 0 {
            LAData.classInfo += Array(repeating: [:], count: numberOfClassesToAdd)
        }
        selectedClassIndex = min(selectedClassIndex, newNum - 1)
    }
}
