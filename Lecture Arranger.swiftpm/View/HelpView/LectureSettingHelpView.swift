//
//  LectureSettingHelpView.swift
//  
//
//  Created by Robert He on 2024/2/21.
//

import SwiftUI

struct LectureSettingHelpView: View {
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
                Image(systemName: "filemenu.and.selection")
                Text("Lecture Setting Help").font(.title).padding(.vertical)
            }
            
            Spacer().frame(height: 30)
            Image(systemName: "info.bubble.rtl")
            Text("Introduction").font(.title)
            Text("  In the Lecture Setting panel, you can set up various types of lectures, and assign different teachers to them.").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 20)
            Image(systemName: "books.vertical")
            Text("Lecture Categories").font(.title)
            Text("  The lectures fall into four different categories, and that partly decides how a lecture's arranged in the schedule.\nThe four categories of lectures can be recognized as two main types: Normal and Unified.\n  For the Normal lectures, you can destribute different teachers for them, and different teachers can deliver different lecture in different classes at the same time, like Math or English.\n  For the Unified lectures, you don't have to set teachers for them, for it's a type of lecture that the classes in the whole grade will have them together in the same period of time. The Unified lectures can be set to be delivered at the first(like morning test) or last(class meeting, for example) lessons only, or at anytime in a day(example: non fixed classroom courses).\n  The first thing to do after adding a lecture is exactly to choose which category the lecture belongs to.").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 30)
            Image(systemName: "10.square.hi")
            Text("Lessons per Week/Class").font(.title)
            Text("  This is a picker where you can decide how many lessons should the lecture be deliverred to each class every week.\n  And we need to point out that, everyday all the classes in the grade would be destributed the same kind and amount of lectures. Therefore, the number you choose here would be quite important, that means if you pick a number bigger than the count of days-in-schedule, there would be a day when students must have two or more same lectures. But if that's exactly what you want, then congratulations because we have applied elaborately designed algorithm when generating your schedule, so in this case, the same class in a day would be arranged to be given in several continuous lessons, and it's likely that it would not cross the lunchtime, except it's the only way. ").padding(.horizontal).multilineTextAlignment(.leading)
            
            Spacer().frame(height: 30)
            Image(systemName: "graduationcap")
            Text("Teacher Settings").font(.title)
            Text("  To add a new teacher for a lecture would be easy, so there's nothing to explain about \"add a teacher\" function, but the time table preparred for every teacher, which can be shown on selecting his/her name in the list.\n  Before generating the schedule, teachers can tell the program the sepcific period of time when they're busy every week by tapping the exact blank in his/her weekly schedule grid view, then a \"Occupied\" sign would show up, which means there won't be a lecture arranged at that time for him/her in the laterly generated schedule. ").padding(.horizontal).multilineTextAlignment(.leading)
            Spacer().frame(height: 50)
        }
    }
}

#Preview {
    LectureSettingHelpView()
}
