//
//  ArrangingDayAlgorithm.swift
//
//
//  Created by Robert He on 2024/2/22.
//

import Foundation

func ArrangeDay(LAData: LA_Data, dayIndex: Int, dayLectures: [String: Int]) -> LA_Data? {
    var newLAData = LAData
    var dayLeCategory: [[String:Int]] = Array(repeating: [:], count: 4)
    for lec in dayLectures.keys { dayLeCategory[newLAData.lectureCategory[lec] ?? 0][lec] = dayLectures[lec] }
    for period in [2,3,1] {
        if let laResult: LA_Data = arrangeUniCourseInDay(LAData: newLAData, dayIndex: dayIndex, period: period, uniLectForPeriod: dayLeCategory[period]) {
            newLAData = laResult
        } else { return nil }
    }
    
    let classArrangeOrder = (0..<newLAData.classNum).shuffled()
    let dayNormLects = dayLeCategory[0].filter{ $0.value > 0 }
    let CDLectures = Array(dayNormLects.keys).sorted{ (item1, item2) -> Bool in return dayNormLects[item1] ?? Int.max > dayNormLects[item2] ?? Int.max }
    
    if let result: LA_Data_Day = arrangeNormCoursesInDay(LADayData: LA_Data_Day(LAData: newLAData, dayIndex: dayIndex),
                                            leftClasses: classArrangeOrder,
                                            cdLectures: CDLectures,
                                            oriCDLectures: CDLectures,
                                            cDayReq: dayNormLects,
                                            argDepth: 0),
       !result.invalied {
        transformDayToWeek(LADayData: result, LAData: &newLAData, dayIndex: dayIndex)
        return newLAData
    } else { return nil }
}

func arrangeUniCourseInDay(LAData: LA_Data, dayIndex: Int, period: Int, uniLectForPeriod: [String: Int]) -> LA_Data? {
    if uniLectForPeriod.isEmpty { return LAData }
    var newLAData = LAData
    let availableTimes = Array(0..<newLAData.amLessonNum + newLAData.pmLessonNum)
        .filter{ newLAData.schedule[dayIndex][$0][0] == "" }
    let uniLectCount = uniLectForPeriod.reduce(0, { $0 + $1.value })
    if uniLectCount == 0 { return LAData }
//    print(uniLectCount)
    if availableTimes.count < uniLectCount {
        return nil
    }
    var lectStartPoint: Int
    var orderArray: Int = 1
    switch period {
    case 1:
        lectStartPoint = Array(availableTimes[0..<(availableTimes.count - uniLectCount)]).randomElement()!
    case 2:
        lectStartPoint = availableTimes.first ?? 0
    case 3:
        lectStartPoint = availableTimes.last ?? 0
        orderArray = -1
    default:
        return nil
    }
    var currentLessonIdx: Int = lectStartPoint
    for uniLect in uniLectForPeriod.keys {
//        print(uniLect)
        for _ in Array(0..<(uniLectForPeriod[uniLect] ?? 0)) {
            for classIdx in 0..<newLAData.classNum {
                newLAData.schedule[dayIndex][currentLessonIdx][classIdx] = uniLect
            }
            currentLessonIdx += orderArray
        }
    }
    return newLAData
}

func arrangeNormCoursesInDay(LADayData: LA_Data_Day, leftClasses: [Int], cdLectures: [String], oriCDLectures: [String], cDayReq: [String:Int], argDepth: Int) -> LA_Data_Day?{
    if leftClasses.isEmpty {
//        print("")
        return LADayData
    }
    
    if cdLectures.isEmpty {
        return arrangeNormCoursesInDay(
            LADayData: LADayData,
            leftClasses: Array(leftClasses.dropFirst()),
            cdLectures: oriCDLectures,
            oriCDLectures: oriCDLectures,
            cDayReq: cDayReq,
            argDepth: argDepth+1
        )
    }
        
    var teacherSchedule: [String]?
    var teacherIndex: Int?
    
    if let teacherName = LADayData.classInfo[leftClasses[0]][cdLectures[0]] ?? LADayData.lecTeacherInfo[cdLectures[0]]?[0],
       let teacherIdx = LADayData.teacherList.firstIndex(of: teacherName) {
        teacherIndex = teacherIdx
        teacherSchedule = LADayData.teacherTimeTable[teacherIdx]
    }

    if let availableStartTimes: [Int] = findAvailableTime(classIndex: leftClasses[0],
                                                          reqNum: cDayReq[cdLectures[0]] ?? 0,
                                                          amLessonNum: LADayData.amLessonNum,
                                                          pmLessonNum: LADayData.pmLessonNum,
                                                          scheduleInDay: LADayData.schedule,
                                                          teacherSchedule: teacherSchedule) {
        
//        print(argDepth, "^]", String(repeating: " ", count: argDepth), leftClasses[0], cdLectures[0], cDayReq[cdLectures[0]]!, availableStartTimes)
        for startTime in availableStartTimes {
            var newLAData = LADayData
            for continueTime in 0..<(cDayReq[cdLectures[0]] ?? 1) {
                newLAData.schedule[continueTime+startTime][leftClasses[0]] = cdLectures[0]
                if let teacherIdx: Int = teacherIndex { newLAData.teacherTimeTable[teacherIdx][continueTime+startTime] += "Class \(leftClasses[0]+1)" }
            }
            if let retResult: LA_Data_Day = arrangeNormCoursesInDay(LADayData: newLAData,
                                                                    leftClasses: leftClasses,
                                                                    cdLectures: Array(cdLectures.dropFirst()),
                                                                    oriCDLectures: oriCDLectures,
                                                                    cDayReq: cDayReq,
                                                                    argDepth: argDepth+1) {
                return retResult
            } else { /*print("OOOps")*/ }
        }
    } else {
        var invaliedData = LADayData
        invaliedData.invalied = true
        return invaliedData
    }
    
    
    return nil
}
