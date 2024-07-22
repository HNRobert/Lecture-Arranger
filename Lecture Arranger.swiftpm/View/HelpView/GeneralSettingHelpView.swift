//
//  GeneralSettingHelpView.swift
//
//
//  Created by Robert He on 2024/2/21.
//

import SwiftUI

struct GeneralSettingHelpView: View {
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
                Image(systemName: "gear")
                Text("General Setting Help").font(.title).padding(.vertical)
            }
            
            Spacer().frame(height: 30)
            Image(systemName: "info.bubble.rtl")
            Text("Introduction").font(.title)
            Text("  This is a panel where you can decide that on which days in a week shall the lectures be given, and choose how many places there are for lectures everyday in the morning and in the afternoon.").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 50)
            
        }
    }
}

#Preview {
    GeneralSettingHelpView()
}
