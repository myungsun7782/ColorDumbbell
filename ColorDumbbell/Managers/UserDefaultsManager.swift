//
//  UserDefaultsManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let IS_INITIALIZED = "isInitialized"
    private let USER_UID = "userUid"
    private let USER_NAME = "userName"
    private let EXERCISE_TIME = "exerciseTime"
    private let TOTAL_EXERCISE_COUNT = "TotalExerciseCount"
    private let DOCUMENT_ID = "documentID"
    private let PUSH_AUTH_STATUS = "pushAuthStatus"
    private let IS_PUSH_INITIALIZED = "isPushInitialized"

    private init() {}
    
    func getIsInitialized() -> Bool {
        return UserDefaults.standard.bool(forKey: IS_INITIALIZED)
    }
    
    func setIsInitialized() {
        UserDefaults.standard.set(true, forKey: IS_INITIALIZED)
    }
    
    func getIsPushInitialized() -> Bool {
        return UserDefaults.standard.bool(forKey: IS_PUSH_INITIALIZED)
    }
    
    func setIsPushInitialized(isInitialized: Bool) {
        UserDefaults.standard.set(isInitialized, forKey: IS_PUSH_INITIALIZED)
    }
    
    func getUserUid() -> String {
        return UserDefaults.standard.string(forKey: USER_UID)!
    }
    
    func setUserUid(userUid: String) {
        UserDefaults.standard.set(userUid, forKey: USER_UID)
    }
    
    func getUserName() -> String {
        return UserDefaults.standard.string(forKey: USER_NAME)!
    }
    
    func setUserName(userName: String) {
        UserDefaults.standard.set(userName, forKey: USER_NAME)
    }
    
    func getExerciseTime() -> Date {
        return UserDefaults.standard.object(forKey: EXERCISE_TIME) as! Date
    }
    
    func setExerciseTime(exerciseTime: Date) {
        UserDefaults.standard.set(exerciseTime, forKey: EXERCISE_TIME)
    }
    
    func getExerciseTotalCount() -> Int {
        return UserDefaults.standard.integer(forKey: TOTAL_EXERCISE_COUNT)
    }
    
    func setExerciseTotalCount(totalExerciseCount: Int) {
        UserDefaults.standard.set(totalExerciseCount, forKey: TOTAL_EXERCISE_COUNT)
    }
    
    func setDocumentID(documentID: String) {
        UserDefaults.standard.set(documentID, forKey: DOCUMENT_ID)
    }
    
    func getDocumentId() -> String {
        return UserDefaults.standard.string(forKey: DOCUMENT_ID)!
    }
    
    func setPushAuthStatus(pushAuthStatus: Bool) {
        UserDefaults.standard.set(pushAuthStatus, forKey: PUSH_AUTH_STATUS)
    }
    
    func getPushAuthStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: PUSH_AUTH_STATUS)
    }
    
    func finishIntialization(uid: String, userName: String, exerciseTime: Date, totalExerciseCount: Int) {
        setUserUid(userUid: uid)
        setUserName(userName: userName)
        setExerciseTime(exerciseTime: exerciseTime)
        setExerciseTotalCount(totalExerciseCount: totalExerciseCount)
        setIsInitialized()
    }
}
