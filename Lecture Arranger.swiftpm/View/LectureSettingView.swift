import SwiftUI

@available(iOS 17.0, *)
struct LectureSettingView: View {
    @Binding var LAData: LA_Data
    @Binding var selectedCourse: String
    
    @State private var showingDetailForTeacher: Teacher? = nil
    @State private var newLectureName: String = ""
    @State private var newTeacherName: String = ""
    @State private var lecAttempts: Int = 0
    @State private var tecAttempts: Int = 0
    @State private var isHelpPresented: Bool = false
    
    let lectCategoryDict: [String] = ["Normal", "Unified (Any time)", "Unified (First lesson)", "Unified (Last lesson)"]
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            HStackLayout{
                Spacer().frame(width: 15)
                TextField("Add a Lecture", text: $newLectureName, onCommit: addLecture)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer().frame(width: 10)
                Button("Add") {
                    addLecture()
                }
                .buttonStyle(.bordered)
                .modifier(ShakeEffect(animatableData: CGFloat(lecAttempts)))
                Spacer().frame(width: 16)
            }
            HStack{
                Spacer().frame(width: 15)
                Picker("", selection: $selectedCourse) {
                    ForEach(LAData.lectureList, id: \.self) { lecture in
                        Text(lecture).tag(lecture) // Use lecture names as tags
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer().frame(width: 15)
            }
            
            if selectedCourse != "" {
                Spacer().frame(height: 20)
                Text("General Settings for \(selectedCourse)")
                    .font(.title2)
                HStack{
                    Spacer().frame(width: 15)
                    Text("Lecture Category")
                    Spacer().frame(width: 5)
                    Picker(selection: Binding(
                        get: {
                            return LAData.lectureCategory[selectedCourse] ?? 0
                        },
                        set: { newValue in
                            LAData.lectureCategory[selectedCourse] = newValue
                        }
                    ), label: Text("")) {
                        ForEach(0..<4) { number in
                            Text("\(lectCategoryDict[number])").tag(number)
                        }
                    }
                    Spacer().frame(width: 16)
                }
                HStack{
                    Spacer().frame(width: 15)
                    Text("Lessons per Week/Class")
                    Spacer().frame(width: 10)
                    Picker(selection: Binding(
                        get: {
                            return LAData.lectureRequirement[selectedCourse] ?? 1
                        },
                        set: { newValue in
                            LAData.lectureRequirement[selectedCourse] = newValue
                        }
                    ), label: Text("")) {
                        ForEach(0..<21) { number in
                            Text("\(number)").tag(number)
                        }
                    }
                    Spacer().frame(width: 16)
                }
                
                
                Spacer().frame(height: 30)
                if !selectedCourse.isEmpty && LAData.lectureCategory[selectedCourse] == 0 {
                    Text("\(selectedCourse) Teachers Setting")
                        .font(.title2)
                    HStack{
                        Spacer().frame(width: 15)
                        TextField("Add Teacher", text: $newTeacherName, onCommit: addTeacher)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer().frame(width: 10)
                        Button("Add") {
                            addTeacher()
                        }
                        .buttonStyle(.bordered)
                        .modifier(ShakeEffect(animatableData: CGFloat(tecAttempts)))
                        Spacer().frame(width: 16)
                    }
                    List {
                        ForEach(LAData.lecTeacherInfo[selectedCourse] ?? [], id: \.self) { teacherName in
                            HStack {
                                Text(teacherName)
                                    .onTapGesture {
                                        self.showingDetailForTeacher = Teacher(id: teacherName)
                                    }
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { self.showingDetailForTeacher = Teacher(id: teacherName) }
                        }
                        .onDelete(perform: deleteTeacher)
                    }
                    .listStyle(.automatic)
                    .sheet(item: $showingDetailForTeacher) { teacher in
                        TeacherDetailView(teacherName: teacher.id, LAData: $LAData)
                    }
                }
            }
            Spacer()
            if !selectedCourse.isEmpty {
                Button("Delete selected Lecture") {
                    deleteLecture()
                }
                .foregroundColor(.red)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
            }
        }.navigationTitle("Lecture Settings")
            .sheet(isPresented: $isHelpPresented, content: {
                LectureSettingHelpView()
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
    
    func addLecture() {
        if newLectureName == "" || LAData.lectureList.contains(newLectureName){
            withAnimation(.default) {
                lecAttempts += 1
            }
            return
        }
        LAData.lectureList.append(newLectureName)
        LAData.lectureRequirement[newLectureName] = LAData.scheduleDays.count
        LAData.lectureCategory[newLectureName] = 0
        selectedCourse = newLectureName
        newLectureName = "" // Resetting the TextField after adding
    }
    
    func deleteLecture() {
        guard let index = LAData.lectureList.firstIndex(of: selectedCourse) else { return }
        LAData.lectureList.remove(at: index)
        
        if index < LAData.lectureList.count {
            selectedCourse = LAData.lectureList[index]
        } else if index - 1 < LAData.lectureList.count && index - 1 >= 0 {
            selectedCourse = LAData.lectureList[max(0, index - 1)]
        } else {
            selectedCourse = ""
        }
    }
    
    func addTeacher() {
        if newTeacherName.isEmpty || selectedCourse.isEmpty || ((LAData.teacherList.contains(newTeacherName)) == true){
            withAnimation(.default) {
                tecAttempts += 1
            }
            return
        }
        let emptyTeacherTimeTable = Array(repeating: Array(repeating: "", count: 7), count: 11)
        LAData.teacherList.append(newTeacherName)
        LAData.teacherTimeTable.append(emptyTeacherTimeTable)
        LAData.teacherBusyStorage.append(emptyTeacherTimeTable)
        if var teachers = LAData.lecTeacherInfo[selectedCourse] {
            teachers.append(newTeacherName)
            LAData.lecTeacherInfo[selectedCourse] = teachers
        } else {
            LAData.lecTeacherInfo[selectedCourse] = [newTeacherName]
        }
        newTeacherName = "" // Resetting the TextField
    }
    
    func deleteTeacher(at offsets: IndexSet) {
        offsets.forEach { index in
            let teacherName = LAData.lecTeacherInfo[selectedCourse]![index]
            let teacherIndex: Int = LAData.teacherList.firstIndex(of: teacherName)!
            LAData.teacherList.remove(at: teacherIndex)
            LAData.teacherTimeTable.remove(at: teacherIndex)
            LAData.teacherBusyStorage.remove(at: teacherIndex)
        }
        LAData.lecTeacherInfo[selectedCourse]!.remove(atOffsets: offsets)
    }
}

struct Teacher: Identifiable {
    let id: String
}
