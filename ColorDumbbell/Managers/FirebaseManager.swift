//
//  FirebaseManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let USER_COLLECTION: String = "users"
    private init() {}
    
    func addUser(user: User, completionHandler: @escaping (_ isSuccess: Bool) -> ()) {
        db.collection(USER_COLLECTION).addDocument(data: [
            UserCodingKeys.uid.rawValue: user.uid,
            UserCodingKeys.name.rawValue: user.name,
            UserCodingKeys.exerciseTime.rawValue: Timestamp(date: user.exerciseTime),
            UserCodingKeys.currentLevel.rawValue: user.currentLevel,
            UserCodingKeys.totalExerciseCount.rawValue: user.totalExerciseCount
        ]) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }
}
