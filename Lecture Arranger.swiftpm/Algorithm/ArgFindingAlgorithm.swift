//
//  ArgFindingAlgorithm.swift
//
//
//  Created by Robert He on 2024/2/23.
//

import Foundation

func generateArray(maxArg: [Int], maxNum: Int, courseCountList: [Int], maxCourse: Int) -> [Int]? {
    let n = maxArg.count
    var z = [Int](repeating: 0, count: n)
    var sum = maxNum

    for i in 0..<n {
        z[i] = sum / (n - i)
        sum -= z[i]
    }
    return findBestArrange(maxArg: maxArg, allPossibilities: permute(z).shuffled(), curCourseforD: courseCountList, maxCourse: maxCourse) ?? nil
}

func findBestArrange(maxArg: [Int], allPossibilities: [[Int]], curCourseforD: [Int], maxCourse: Int) -> [Int]? {
//    print(curCourseforD, "<-",  allPossibilities)
//    print("maxArg: " , maxArg)
//    print("maxNum", maxCourse)
    let validArrays = allPossibilities.filter { e in
        for (index, value) in e.enumerated() where !(value <= maxArg[index] && value + curCourseforD[index] <= maxCourse) {
            return false
        }
        return true
    }
    
    guard !validArrays.isEmpty else { return nil }
    
    var minVarianceArray: [Int]?
    var minVariance: Double?
    
    for e in validArrays {
        let mean = Double(e.enumerated().map { Double($1 + curCourseforD[$0]) }.reduce(0, +)) / Double(e.count)
        let variance = e.enumerated().map { pow(Double($1 + curCourseforD[$0]) - mean, 2) }.reduce(0, +) / Double(e.count)
        
        if let currentMinVariance = minVariance {
            if variance < currentMinVariance {
                minVariance = variance
                minVarianceArray = e
            }
        } else {
            minVariance = variance
            minVarianceArray = e
        }
    }
    
    return minVarianceArray
}

func findAvailableTime(classIndex: Int, reqNum: Int, amLessonNum: Int, pmLessonNum: Int, scheduleInDay: [[String]], teacherSchedule: [String]?) -> [Int]? {
    var availableStartTimes = [Int]()
    var crossTimes = [Int]()
    var teacherShortNum: Int = 0
    var scheduleShortNum: Int = 0
    let totalLessons = amLessonNum + pmLessonNum
    
    for timeIndex in 0...(totalLessons - reqNum) {
        var isAvailable = true
        var isCross = false

        for offset in 0..<reqNum {
            let currentTime = timeIndex + offset

            // Check if the time crosses the AM and PM sessions
            if (timeIndex < amLessonNum && currentTime >= amLessonNum) || currentTime == totalLessons - 1 {
                isCross = true
            }
            
            // Check if the time slot is available for both class and teacher
            if scheduleInDay[currentTime][classIndex] != "" {
                teacherShortNum += 1
                isAvailable = false
                break
            }
            if (teacherSchedule?[currentTime] ?? "") != "" {
                scheduleShortNum += 1
                isAvailable = false
                break
            }
        }
        
        if isAvailable {
            isCross ? crossTimes.append(timeIndex) : availableStartTimes.append(timeIndex)
        }
    }
    
    availableStartTimes.shuffle()
    availableStartTimes.append(contentsOf: crossTimes.shuffled())
    if !availableStartTimes.isEmpty {
        return availableStartTimes
    } else {
        return teacherShortNum > scheduleShortNum ? [] : nil
    }
}

