//
//  GenerateExportHelpView.swift
//
//
//  Created by Robert He on 2024/2/23.
//

import SwiftUI

struct GenerateExportHelpView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            Spacer().frame(height: 15)
            HStack{
                Spacer().frame(width: 15)
                Button(action: { dismiss() }) {
                    Label("Back ", systemImage: "chevron.backward")
                } .buttonStyle(.borderless)
                Spacer()
            }
            Spacer().frame(height: 30)
            HStack {
                Image(systemName: "calendar.badge.plus")
                Text("Generate/Export schedule Help").font(.title).padding(.vertical)
            }
            
            Spacer().frame(height: 30)
            Image(systemName: "info.bubble.rtl")
            Text("Introduction").font(.title)
            Text("  This might be your final step if you have completed the previous settings correctly. Just click the \"Generate Schedule\" button and check the miracle!").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 30)
            Image(systemName: "square.grid.3x3.middle.filled")
            Text("Generating a pretty schedule").font(.title)
            Text("  There are random factors added when generating a schedule, so if you're not satisfied about the schedule currently shown to you, try press the generate button again and see if there would be another surprise.\n  And, if you want to save the current time table in the app as well as the configs you set, please turn to \"Add/Manage Savings\" Panel, and the next time when you want to generate another time table using the same configuration, you only need to read it from there and click the generate button again, instead of doing the previous settings repeatedly.").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 30)
            Image(systemName: "square.and.arrow.up")
            Text("Export it!").font(.title)
            Text("  That's a very important function when it comes to efficency. Press the export button at the upper right corner and you can export the xlsx file to local files, then you may further edit the table we've generated for you, and print it out.").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 50)
        }
    }
}

#Preview {
    GenerateExportHelpView()
}
