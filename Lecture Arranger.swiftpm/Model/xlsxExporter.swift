//
//  xlsxExporter.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/17.
//

import SwiftUI
import libxlsxwriter
import UniformTypeIdentifiers

func generateScheduleXlsx(data: LA_Data) {
    let tempDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = tempDirectory.appendingPathComponent("output.xlsx")
    let filePath = fileURL.path
    print(filePath)
    
    filePath.withCString { cPath in
        guard let xBook = workbook_new(cPath) else {
            print("Error creating workbook")
            return
        }
        
        let titleFormat = workbook_add_format(xBook)

        format_set_bold(titleFormat)
        format_set_font_size(titleFormat, 20)
        format_set_align(titleFormat, UInt8(LXW_ALIGN_CENTER.rawValue))
        format_set_align(titleFormat, UInt8(LXW_ALIGN_VERTICAL_CENTER.rawValue))
        
        let textFormat = workbook_add_format(xBook)
        format_set_align(textFormat, UInt8(LXW_ALIGN_CENTER.rawValue))
        format_set_align(textFormat, UInt8(LXW_ALIGN_VERTICAL_CENTER.rawValue))
        
        for dayName in data.scheduleDays {
            let aDayIdx = data.scheduleDays.firstIndex(of: dayName)!
            let dateName = data.scheduleDays[aDayIdx]
            guard let scheduleSheet = workbook_add_worksheet(xBook, "\(dateName)".cString(using: .utf8)) else {
                print("Error creating worksheet for \(dateName)")
                continue
            }
            proceedScheduleSheet(data: data, sheet: scheduleSheet, dateIdx: aDayIdx, titleFormat: titleFormat, textFormat: textFormat)
        }
        
        workbook_close(xBook)
    }
}

func proceedScheduleSheet(data: LA_Data, sheet: UnsafeMutablePointer<lxw_worksheet>?, dateIdx: Int, titleFormat: UnsafeMutablePointer<lxw_format>?, textFormat: UnsafeMutablePointer<lxw_format>?) {
    let classNum = data.classNum
    worksheet_merge_range(sheet, 0, 0, 0, lxw_col_t(classNum), data.scheduleDays[dateIdx], titleFormat)
    for className in 1...classNum {
        worksheet_write_string(sheet, 1, lxw_col_t(className), "Class \(className)", textFormat)
    }
    for lessonIdx in 0...(data.amLessonNum + data.pmLessonNum) {
        var showLessonName = "L\(lessonIdx+1)"
        var lessonBlankAdjust = 0
        if lessonIdx > data.amLessonNum {
            showLessonName = "L\(lessonIdx)"
            lessonBlankAdjust = 1
        } else {
            if lessonIdx == data.amLessonNum {
                continue
            }
        }
        
        worksheet_write_string(sheet, lxw_row_t(lessonIdx+2), 0, showLessonName, textFormat)
        
        for classIdx in 0..<classNum {
            worksheet_write_string(sheet, lxw_row_t(lessonIdx+2), lxw_col_t(classIdx+1), data.schedule[dateIdx][lessonIdx-lessonBlankAdjust][classIdx], textFormat)
        }
    }
}


struct XLSXFile: FileDocument {
    static var readableContentTypes: [UTType] { [.init(filenameExtension: "xlsx")!] }

    var data: Data

    init(data: Data) {
        self.data = data
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.data = data
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: data)
    }
}
