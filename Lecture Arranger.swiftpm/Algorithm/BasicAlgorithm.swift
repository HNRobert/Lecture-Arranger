//
//  BasicAlgorithm.swift
//  Lecture Arranger
//
//  Created by Robert He on 2024/2/17.
//

import Foundation

func teachableNumForDay(LAData: LA_Data, teacher: String, day: Int) -> Int {
    let teacherIndex = LAData.teacherList.firstIndex(of: teacher)!
    return LAData.teacherTimeTable[teacherIndex].map{ $0[day] }.filter { $0 == "" }.count
}

func assignedClassNumForTeacher(LAData: LA_Data, teacher: String, teacherIdx: Int, lectureName: String) -> Int {
    let result = LAData.classInfo.reduce(0) { result, classTeachingInfo in
        let lectureExists = classTeachingInfo.keys.contains(lectureName)
        let shouldCount = lectureExists ? (classTeachingInfo[lectureName] == teacher || classTeachingInfo[lectureName] == "") : teacherIdx == 0
        return result + (shouldCount ? 1 : 0)
    }
    return max(result, 1)
}



func transformDayToWeek(LADayData: LA_Data_Day, LAData: inout LA_Data, dayIndex: Int) {
    for (teacherIdx, daySchedules) in LADayData.teacherTimeTable.enumerated() {
        for (timeSlotIdx, schedule) in daySchedules.enumerated() {
            LAData.teacherTimeTable[teacherIdx][timeSlotIdx][dayIndex] = schedule
        }
    }
    for lecIdx in 0..<LAData.amLessonNum+LAData.pmLessonNum {
        for clsIdx in 0..<LAData.classNum {
            LAData.schedule[dayIndex][lecIdx][clsIdx] = LADayData.schedule[lecIdx][clsIdx]
        }
    }
}

func permute(_ nums: [Int]) -> [[Int]] {
    var result = [[Int]]()
    var nums = nums.sorted()
    
    func backtrack(_ start: Int) {
        if start == nums.count {
            result.append(nums)
            return
        }
        
        var seen = Set<Int>()
        for i in start..<nums.count {
            if seen.insert(nums[i]).inserted == false {
                continue
            }
            nums.swapAt(start, i)
            backtrack(start + 1)
            nums.swapAt(start, i)
        }
    }
    
    backtrack(0)
    return result
}
