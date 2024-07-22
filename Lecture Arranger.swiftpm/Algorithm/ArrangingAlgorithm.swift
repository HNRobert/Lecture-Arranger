
import Foundation

func calculateLectureTable(LAData: inout LA_Data) -> Bool? {
    let weekDaysOrder: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let lessonNum = LAData.amLessonNum + LAData.pmLessonNum
    LAData.teacherTimeTable = LAData.teacherBusyStorage
    LAData.schedule = Array(repeating: Array(repeating: Array(repeating: "", count: 21), count: 11), count: 7)
    let fullNum = LAData.scheduleDays.count * lessonNum * LAData.classNum
    let totalLectures = LAData.lectureRequirement.filter { LAData.lectureList.contains($0.key) }.values.reduce(0, +) * LAData.classNum
//    print(fullNum, totalLectures)
    if totalLectures > fullNum {
        return nil
    }
    
    var dailyLectureDistribution: [[String: Int]]
    if let distribution = calculateDailyLectureDistribution(LAData: &LAData) {
        dailyLectureDistribution = distribution
    } else { return false }
    
    for dayName in LAData.scheduleDays {
        let dayIndex: Int = weekDaysOrder.firstIndex(of: dayName)!
//        print("\n DAY\(dayIndex+1)")
//        print("reqDay: \(dailyLectureDistribution[dayIndex])")
        var succ = false
        for _ in 0..<10 {
            if let outLAData = ArrangeDay(LAData: LAData, dayIndex: dayIndex, dayLectures: dailyLectureDistribution[dayIndex]){
                LAData = outLAData
                succ = true
                break
            }
        }
        if !succ {
            return false
        }
    }

    return true
}

func calculateDailyLectureDistribution(LAData: inout LA_Data) -> [[String: Int]]? {
    var dailyLectureDistribution: [[String: Int]] = Array(repeating: [String: Int](), count: LAData.scheduleDays.count)
    var dailyLectureCount: [Int] = Array(repeating: 0, count: LAData.scheduleDays.count)
    
    let lessonNum = LAData.amLessonNum + LAData.pmLessonNum
    
    var lectureTypeList: [[String]] = [[],[]]  // [uni, norm]
    for lec in LAData.lectureList { lectureTypeList[LAData.lectureCategory[lec] ?? 0 > 0 ? 0 : 1].append(lec) }
    let lecArgOrder: [String] = lectureTypeList.flatMap { $0 }
    
    for lecture in lecArgOrder {
//        print(lecture)
        let totalLectures = LAData.lectureRequirement[lecture] ?? 0
        var teachRequest: [String: Int] = [:]
        var maxArg: [Int] = []
        var teacherIdx = 0
        for teacher in LAData.lecTeacherInfo[lecture] ?? [] {
            teachRequest[teacher] = assignedClassNumForTeacher(LAData: LAData, teacher: teacher, teacherIdx: teacherIdx, lectureName: lecture)
            teacherIdx += 1
        }
        
        for dayIndex in 0..<LAData.scheduleDays.count {
//            print("Day", dayIndex)
            let uniCourseNum = dailyLectureDistribution[dayIndex].reduce(0) { result, pair in
                let (key, value) = pair
                return lectureTypeList[0].contains(key) ? result + value : result
            }
            var maxCourseNumForDay = lessonNum - dailyLectureCount[dayIndex]
            for teacher in LAData.lecTeacherInfo[lecture] ?? [] {
                let spaceLessonNum = min(teachableNumForDay(LAData: LAData, teacher: teacher, day: dayIndex), lessonNum - uniCourseNum)
                let teachingReq: Int = teachRequest[teacher] ?? 1
                let maxForTeacher = Int(spaceLessonNum / teachingReq)
//                print(teacher, maxForTeacher, spaceLessonNum, teachingReq)
                maxCourseNumForDay = min(maxCourseNumForDay, maxForTeacher)
            }
            maxArg.append(maxCourseNumForDay)
        }
//        print(lecture, "max: ", maxArg)
        if maxArg.reduce(0, +) < totalLectures {
            return nil
        }
        
        let bestArg = generateArray(maxArg: maxArg, maxNum: totalLectures, courseCountList: dailyLectureCount, maxCourse: lessonNum)
//        print(lecture, bestArg!)
        if bestArg == nil { return nil }
        
        for (dayIndex, distributedLectNum) in bestArg!.enumerated() {
            dailyLectureDistribution[dayIndex][lecture, default: 0] += distributedLectNum
            dailyLectureCount[dayIndex] += distributedLectNum
        }
    }
    
    return dailyLectureDistribution
}



struct LA_Data_Day {
    var pmLessonNum: Int
    var amLessonNum: Int
    var schedule: [[String]]
    var lecTeacherInfo: [String: [String]]
    var teacherList: [String]
    var teacherTimeTable: [[String]]
    var classInfo: [[String: String]]
    var scheduleDays: [String]
    var invalied: Bool = false
    
    init(LAData: LA_Data, dayIndex: Int) {
        self.amLessonNum = LAData.amLessonNum
        self.pmLessonNum = LAData.pmLessonNum
        self.schedule = Array(repeating: Array(repeating: "", count: LAData.classNum), count: self.amLessonNum + self.pmLessonNum)
        for lsn in 0..<amLessonNum + pmLessonNum {
            for cls in 0..<LAData.classNum {
                self.schedule[lsn][cls] = LAData.schedule[dayIndex][lsn][cls]
            }
        }
        self.lecTeacherInfo = LAData.lecTeacherInfo
        self.teacherList = LAData.teacherList
        self.teacherTimeTable = LAData.teacherTimeTable.map { $0.map { $0[dayIndex] } }
        self.classInfo = LAData.classInfo
        self.scheduleDays = LAData.scheduleDays
    }
}
