//
//  SaveManagementView.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/15.
//

import SwiftUI

struct SaveManagementView: View {
    @Binding var LAData: LA_Data
    @Binding var selectedCourse: String
    
    @State private var newConfigName: String = ""
    @State private var cfgAttempts: Int = 0
    @State private var showLabel: String = "Give the new saving a name, \nor enter a previous saving's name to replace it"

    @State private var LASaves: [String] = DataStorage.shared.listAllSaves()
    @State private var showLabel2: String = "Select a saving and you can read or delete it"
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            Text("Save current data")
                .font(.title)
            Text(showLabel)
                .multilineTextAlignment(.center)
            HStackLayout{
                Spacer().frame(width: 15)
                TextField("Enter Config's Name", text: $newConfigName) {
                    _save()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                Spacer().frame(width: 10)
                Button("Save") {
                    _save()
                }
                .buttonStyle(.bordered)
                .modifier(ShakeEffect(animatableData: CGFloat(cfgAttempts)))
                Spacer().frame(width: 16)
            }
            Spacer().frame(height: 30)
            if LASaves != [] {
                Text("Manage saved datas")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Text(showLabel2).multilineTextAlignment(.center)
                List {
                    ForEach(LASaves, id: \.self) { LASave in
                        HStack {
                            Text(LASave)
                                .onTapGesture {
                                    _read(saveName: LASave)
                                }
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { _read(saveName: LASave) }
                    }
                    .onDelete(perform: _delete)
                }.listStyle(.automatic)
            }
            Spacer()
        }.navigationTitle("Add/Manage Savings")
    }
    
    func _read(saveName: String) {
        if let loadedData = DataStorage.shared.readData(withName: saveName) {
            showLabel2 = "Data \"\(saveName)\" loaded successfully!"
            LAData = loadedData
            if !LAData.lectureList.isEmpty {
                selectedCourse = LAData.lectureList[0]
            } else {
                selectedCourse = ""
            }
        } else {
            showLabel2 = "Failed to load data \"\(saveName)\""
        }
    }
    
    func _save() {
        switch saveLAData(newConfigName: newConfigName, cfgAttempts: &cfgAttempts, LAData: LAData) {
        case nil:
            showLabel = "Failed to save: Please enter a name for the config"
        case true:
            showLabel = "Data \"\(newConfigName)\" saved successfully!"
        default:
            showLabel = "Failed to save data \"\(newConfigName)\""
        }
        LASaves = DataStorage.shared.listAllSaves()
    }
    
    func _delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let saveName = LASaves[index]
            DataStorage.shared.deleteData(withName: saveName)
        }
        LASaves.remove(atOffsets: offsets)
    }
}
