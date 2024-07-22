import SwiftUI

@available(iOS 17.0, *)
struct ContentView: View {
    @State private var LAData = LA_Data()
    @State private var selectedView: SelectedView?
    @State private var selectedCourse: String = ""
    
    
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List(selection: $selectedView) {
                Section("Settings") {
                    NavigationLink(value: SelectedView.generalSettings) {
                        Image(systemName: "gear").frame(width: 25)
                        Text("General")
                    }
                    NavigationLink(value: SelectedView.lectureSettings) {
                        Image(systemName: "filemenu.and.selection").frame(width: 25)
                        Text("Lecture")
                    }
                    NavigationLink(value: SelectedView.classInfoSettings) {
                        Image(systemName: "book.pages").frame(width: 25)
                        Text("Class information")
                    }
                }
                
                Section("Generating") {
                    NavigationLink(value: SelectedView.preview) {
                        Image(systemName: "calendar.badge.plus").frame(width: 25)
                        Text("Generate/Export schedule")
                    }
                }
                
                Section("Data Management") {
                    NavigationLink(value: SelectedView.savemgr){
                        Image(systemName: "square.and.arrow.down.on.square").frame(width: 25)
                        Text("Add/Manage Savings")
                    }
                }
                
                Section("Help") {
                    NavigationLink(value: SelectedView.instructions){
                        Image(systemName: "gear.badge.questionmark").frame(width: 25)
                        Text("Instructions")
                    }
                }
            }
            .navigationTitle("Menu")
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(ideal: 500)
        } detail: {
            // Primary content area
            switch selectedView {
            case .generalSettings:
                GeneralSettingView(LAData: $LAData)
            case .lectureSettings:
                LectureSettingView(LAData: $LAData, selectedCourse: $selectedCourse)
            case .classInfoSettings:
                ClassSettingView(LAData: $LAData)
            case .preview:
                PreviewView(LAData: $LAData)
            case .savemgr:
                SaveManagementView(LAData: $LAData, selectedCourse: $selectedCourse)
            case .instructions:
                InstructionView(LAData: $LAData)
            default:
                InstructionView(LAData: $LAData)
            }
        }
    }
}

enum SelectedView: Hashable {
    case generalSettings, lectureSettings, classInfoSettings, preview, savemgr, instructions
}

struct SelectableItem: Identifiable, Hashable {
    let id: UUID
    var name: String

    init(id: UUID = UUID(), name: String = "Item") {
        self.id = id
        self.name = name
    }
}

struct LA_Data: Codable {
    var pmLessonNum: Int = 3
    var amLessonNum: Int = 3
    var classNum: Int = 2
    var schedule: [[[String]]] = Array(repeating: Array(repeating: Array(repeating: "", count: 21), count: 11), count: 7)
    var lectureList: [String] = []
    var lectureCategory: [String: Int] = [:]  // 0:Normal, 1:Unified any time, 2:Unified first lesson only, 3:Unified last lesson only
    var lectureRequirement: [String: Int] = [:]
    var lecTeacherInfo: [String: [String]] = [:]
    var teacherList: [String] = []
    var teacherTimeTable: [[[String]]] = []
    var teacherBusyStorage: [[[String]]] = []
    var classInfo: [[String: String]] = [[:], [:]]
    var scheduleDays: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

@available(iOS 17.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
