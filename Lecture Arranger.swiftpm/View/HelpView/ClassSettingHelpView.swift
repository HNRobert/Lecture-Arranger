//
//  ClassSettingHelpView.swift
//
//
//  Created by Robert He on 2024/2/23.
//

import SwiftUI

struct ClassSettingHelpView: View {
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
                Image(systemName: "book.pages")
                Text("Class Information Setting Help").font(.title).padding(.vertical)
            }
            
            Spacer().frame(height: 30)
            Image(systemName: "info.bubble.rtl")
            Text("Introduction").font(.title)
            Text("  Since the classes' number and distribution of teachers for each class is not what we can decide, but you, so there's another important setting panel for you which enables you to set up some basic information for the classes.").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 30)
            Image(systemName: "graduationcap")
            Text("Teachers Setting").font(.title)
            Text("  Here's the place for you to choose the teachers for every class. Remember that don't give any teacher too much burden, otherwise errors would show when generating the schedule table, your next step after this").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 50)
        }
    }
}

#Preview {
    ClassSettingHelpView()
}
