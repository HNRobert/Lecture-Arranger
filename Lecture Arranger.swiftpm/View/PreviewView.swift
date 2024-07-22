//
//  PreviewView.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/10.
//

import SwiftUI

@available(iOS 17.0, *)
struct PreviewView: View {
    @Binding var LAData: LA_Data
    
    @State private var selectedDayIndex = 0
    @State private var selectedItemIndex: [Int] = [0,0]
    @State private var isTeacher: Bool = false
    @State private var Textvar: String = "Press the Button to generate the schedule"
    @State private var isExporting: Bool = false
    @State private var isHelpPresented: Bool = false
    
    var body: some View {
        ScrollView{
            VStack {
                Spacer().frame(height: 20)
                Button("Generate Schedule"){
                    Textvar = "Generating..."
                    GenerateTable()
                }.buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                Spacer().frame(height: 10)
                Text(Textvar).multilineTextAlignment(.center)
                
                
                Text("Grade View").font(.title).padding()
                Picker("", selection: $selectedDayIndex) {
                    ForEach(0..<LAData.scheduleDays.count, id: \.self) { day in
                        Text(LAData.scheduleDays[day]).tag(day)
                    }
                }.pickerStyle(.segmented)
                TableView(LAData: $LAData, selectedSheetIdx: $selectedDayIndex, isTeacher: $isTeacher, selectedItemIndex: $selectedItemIndex, columnNameList: GenerateClassName(classNumber: LAData.classNum))
                Spacer().frame(height: 40)
            }
            .sheet(isPresented: $isHelpPresented, content: {
                GenerateExportHelpView()
            })
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        isHelpPresented = true
                    }
                           , label: {
                        Image(systemName: "questionmark.circle")
                    })
                }
                ToolbarItem {
                    ExportButton(LAData: $LAData, isExporting: $isExporting, textVar: $Textvar)
                }
            }
            
        }
        .padding()
        .navigationTitle("Generate/Export")
    }
    
    
    
    func GenerateTable() {
        switch calculateLectureTable(LAData: &LAData) {
        case nil:
            Textvar = "Invalied Request, Too many Courses"
        case false:
            Textvar = "Invalied Request, Too many Courses, or a too-busy teacher exists"
        case true:
            Textvar = "Success!"
        default:
            Textvar = "Failed to generate"
        }
    }
    
    func GenerateClassName(classNumber: Int) -> [String] {
        var classNamesList: [String] = []
        for classIndex in 1...classNumber {
            classNamesList.append("Class \(classIndex)")
        }
        return classNamesList
    }
}


struct ExportButton: View {
    @Binding var LAData: LA_Data
    @Binding var isExporting: Bool
    @Binding var textVar: String
    
    @State private var document: XLSXFile?
    
    var body: some View {
        Button(action: {
            DispatchQueue.global(qos: .userInitiated).async {
                generateScheduleXlsx(data: LAData)
                
                DispatchQueue.main.async {
                    guard let xlsxData = loadXlsx() else { return }
                    document = XLSXFile(data: xlsxData)
                    isExporting = true
                }
            }
        }) {
            Image(systemName: "square.and.arrow.up")
        }
        .fileExporter(
            isPresented: $isExporting,
            document: document,
            contentType: .init(filenameExtension: "xlsx") ?? .data,
            defaultFilename: "Schedule.xlsx"
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    textVar = "Schedule Exported successfully."
                case .failure(let error):
                    textVar = "Failed to Exported Scheudle: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    
    func loadXlsx() -> Data? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent("output.xlsx")
        return try? Data(contentsOf: fileURL)
    }
    
    func generateAndLoadXlsx(data: LA_Data) async {
        generateScheduleXlsx(data: data) // Ensure this runs to completion
        await MainActor.run {
            guard let xlsxData = loadXlsx() else { return }
            document = XLSXFile(data: xlsxData)
            isExporting = true
        }
    }
}

