//
//  SwiftUIView.swift
//  
//
//  Created by Robert He on 2024/2/20.
//

import SwiftUI

struct InstructionView: View {
    @Binding var LAData: LA_Data
    @State private var activeHelpPage: HelpPage? = nil
    @State private var showingSheet: Bool = false
    @State private var demoText: String = "Load Demo Config"

    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            Text("Welcome to Lecture Arranger!").font(.title).padding(.horizontal).multilineTextAlignment(.center)
            Text("Select \"General Settings\" to get started").padding(.horizontal).multilineTextAlignment(.leading)
            Spacer().frame(height: 20)
            Text("  This is a app designed to help school administrators to arrange lectures' time table for a whole grade, or more.\n  It supports various arranging styles, and can generate/export the time table into xlsx files in a second.").padding(.horizontal).multilineTextAlignment(.leading)
            Spacer().frame(height: 20)
            Text("View the following instructions for further help about how it works").font(.title2).padding(.horizontal).multilineTextAlignment(.leading)
            List {
                Section {
                    HelpListColumn(activeHelpPage: $activeHelpPage, showName: "General Setting Help", imageName: "gear", helpPage: .generalSetting)
                    HelpListColumn(activeHelpPage: $activeHelpPage, showName: "Lecture Setting Help", imageName: "filemenu.and.selection", helpPage: .lectureSetting)
                    HelpListColumn(activeHelpPage: $activeHelpPage, showName: "Class Setting Help", imageName: "book.pages", helpPage: .classSetting)
                    HelpListColumn(activeHelpPage: $activeHelpPage, showName: "Generate/Export Help", imageName: "calendar.badge.plus", helpPage: .generateExport)
                }
                Section {
                    HStack {
                        Image(systemName: "gift").frame(width: 25)
                        Button(demoText) {
                            LoadLADemo(LAData: &LAData)
                            demoText = "Success!"
                        }
                        .contentShape(Rectangle())
                        .onTapGesture { LoadLADemo(LAData: &LAData); demoText="Success!" }
                    }
                }
            }
            Spacer()
        }
        .sheet(item: $activeHelpPage) { page in
                    switch page {
                    case .generalSetting:
                        GeneralSettingHelpView()
                    case .lectureSetting:
                        LectureSettingHelpView()
                    case .classSetting:
                        ClassSettingHelpView()
                    case .generateExport:
                        GenerateExportHelpView()
                    }
                }
        .navigationTitle("Instructions")
    }
}

enum HelpPage: Identifiable {
    case generalSetting
    case lectureSetting
    case classSetting
    case generateExport

    var id: Self { self }
}
struct HelpListColumn: View {
    @Binding var activeHelpPage: HelpPage?
    let showName: String
    let imageName: String
    let helpPage: HelpPage
    
    var body: some View {
        HStack {
            Image(systemName: imageName).frame(width: 25)
            Button(showName) {
                activeHelpPage = helpPage
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { activeHelpPage = helpPage }
    }
}
