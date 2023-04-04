//
//  FirebaseManager.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/07.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import SwiftDate

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let USER_COLLECTION: String = "users"
    private let DEFAULT_EXERCISE_COLLECTION: String = "defaultExercise"
    private let EXERCISE_JOURNAL_COLLECTION: String = "exerciseJournals"
    private let EXERCISE_LIST_COLLECTION: String = "exerciseList"
    private let CUSTOM_EXERCISE_COLLECTION: String = "customExercises"
    private let ROUTINE_COLLECTION: String = "routines"
    private let storageUrl = "gs://colordumbbell.appspot.com/"
    private init() {}
    
    func uploadImage(photoAndIdList: Array<(UIImage, String)>, completionHandler: @escaping (_ photoIdList: Array<String>) -> ()) {
        var photoIdList = Array<(String, Bool)>()
        
        for (idx, _) in photoAndIdList.enumerated() {
            photoIdList.append((photoAndIdList[idx].1, false))
        }
        
        for (idx, _) in photoAndIdList.enumerated() {
            var data = Data()
            data = photoAndIdList[idx].0.jpegData(compressionQuality: 0.2)!
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/png"
            
            storage.reference().child(photoIdList[idx].0).putData(data, metadata: metaData) { (md, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                print("Successfully Upload Photo")
                photoIdList[idx].1 = true
                if self.isImageListUploadDone(photoIdList: photoIdList) {
                    var resultList = Array<String>()
                    
                    photoIdList.forEach { (id, _) in
                        resultList.append(id)
                    }
                    completionHandler(resultList)
                }
            }
        }
    }
    
    private func isImageListUploadDone(photoIdList: Array<(String, Bool)>) -> Bool {
        for photoId in photoIdList {
            let isUploadDone: Bool = photoId.1
            if !isUploadDone {
                return false
            }
        }
        return true
    }
    
    func downloadImagese(fileNameList: [String], completionHandler: @escaping (_ photoAndIdList: [(UIImage, String)]) -> ()) {
        var photoAndIdList = Array<(UIImage, String)>()
        var photoIdList = Array<(String, Bool)>()
        
        for (idx, _) in fileNameList.enumerated() {
            photoIdList.append((fileNameList[idx], false))
        }
        
        for (idx, fileName) in fileNameList.enumerated() {
            DispatchQueue.global().sync {
                storage.reference(forURL: storageUrl + fileName).downloadURL { (url, error) in
                    DispatchQueue.global().async {
                        let data = NSData(contentsOf: url!)
                        let image = UIImage(data: data! as Data)
                        photoAndIdList.append((image!, fileName))
                        photoIdList[idx].1 = true
                        print("Successfully download images")
                        if self.isImageListUploadDone(photoIdList: photoIdList) {
                            completionHandler(photoAndIdList)
                        }
                    }
                }
            }
        }
    }
    
    func addUser(user: User, completionHandler: @escaping (_ isSuccess: Bool) -> ()) {
        var ref: DocumentReference? = nil
        ref = db.collection(USER_COLLECTION).addDocument(data: [
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
                UserDefaultsManager.shared.setDocumentID(documentID: ref!.documentID)
                self.getDefaultExercises { exerciseArray in
                    var exerciseList: [Exercise] = exerciseArray
                    for (idx, exercise) in exerciseList.enumerated() {
                        self.db.collection(self.USER_COLLECTION)
                            .document(ref!.documentID)
                            .collection(self.DEFAULT_EXERCISE_COLLECTION)
                            .addDocument(data: [
                                "id": exercise.id,
                                "exerciseName": exercise.name,
                                "exerciseArea": exercise.area,
                                "sequence": idx,
                                "exerciseType": exercise.type
                            ]) { err in
                                if let err = err {
                                    print(err.localizedDescription)
                                    completionHandler(false)
                                } else {
                                    completionHandler(true)
                                }
                            }
                    }
                }
            }
        }
    }
    
    func addExerciseJournal(exerciseJournal: ExerciseJournal, completionHandler: @escaping (_ isSuccess: Bool) -> ()) {
        var ref: DocumentReference? = nil
        ref = db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(EXERCISE_JOURNAL_COLLECTION)
            .addDocument(data: [
                "id" : exerciseJournal.id,
                "title": exerciseJournal.title,
                "registerDate": Timestamp(date: exerciseJournal.registerDate),
                "startTime": Timestamp(date: exerciseJournal.startTime),
                "endTime": Timestamp(date: exerciseJournal.endTime),
                "totalExerciseTime": exerciseJournal.totalExerciseTime,
                "photoIdArray": exerciseJournal.photoIdArray!,
            ]) { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                    completionHandler(false)
                } else {
                    let exerciseArray = exerciseJournal.exerciseArray
                    
                    for (idx, exercise) in exerciseArray.enumerated() {
                        var weightAndReps: [[String: Any]] = []
    
                        for quantity in exercise.quantity {
                            var quantityDict = [String: Any]()
                            quantityDict["weight"] = quantity.weight
                            quantityDict["reps"] = quantity.reps
                            
                            weightAndReps.append(quantityDict)
                        }
                        
                        ref!.collection(self.EXERCISE_LIST_COLLECTION)
                            .addDocument(data: [
                                "sequence": idx,
                                "quantityList": weightAndReps,
                                "id": exercise.id,
                                "exerciseName": exercise.name,
                                "exerciseArea": exercise.area,
                                "exerciseType": exercise.type
                            ]) { err in
                                if let err = err {
                                    print(err.localizedDescription)
                                } else {
                                    print("Successfully save exercise")
                                }
                            }
                    }
                    completionHandler(true)
                }
            }
    }
    
    func modifyExerciseJournal(exerciseJournal: ExerciseJournal, completionHandler: @escaping (_ isSuccess: Bool) -> ()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(EXERCISE_JOURNAL_COLLECTION)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as! String
                        if id == exerciseJournal.id {
                            document.reference.updateData([
                                "id" : exerciseJournal.id,
                                "title": exerciseJournal.title,
                                "registerDate": Timestamp(date: exerciseJournal.registerDate),
                                "startTime": Timestamp(date: exerciseJournal.startTime),
                                "endTime": Timestamp(date: exerciseJournal.endTime),
                                "totalExerciseTime": exerciseJournal.totalExerciseTime,
                                "photoIdArray": exerciseJournal.photoIdArray!,
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err.localizedDescription)")
                                } else {
                                    document.reference
                                        .collection(self.EXERCISE_LIST_COLLECTION)
                                        .getDocuments { (querySnapshot, err) in
                                            for document in querySnapshot!.documents {
                                                document.reference.delete()
                                            }
                                            let exerciseArray = exerciseJournal.exerciseArray
                                            
                                            for (idx, exercise) in exerciseArray.enumerated() {
                                                var weightAndReps: [[String: Any]] = []
                            
                                                for quantity in exercise.quantity {
                                                    var quantityDict = [String: Any]()
                                                    quantityDict["weight"] = quantity.weight
                                                    quantityDict["reps"] = quantity.reps
                                                    
                                                    weightAndReps.append(quantityDict)
                                                }
                                                
                                                document.reference.collection(self.EXERCISE_LIST_COLLECTION)
                                                    .addDocument(data: [
                                                        "sequence": idx,
                                                        "quantityList": weightAndReps,
                                                        "id": exercise.id,
                                                        "exerciseName": exercise.name,
                                                        "exerciseArea": exercise.area
                                                    ]) { err in
                                                        if let err = err {
                                                            print(err.localizedDescription)
                                                        } else {
                                                            print("Successfully save exercise")
                                                        }
                                                    }
                                            }
                                            completionHandler(true)

                                        }
                                }
                            }
                            
                        }
                    }
                }
            }
    }
    
    func deleteExerciseJournal(exerciseJournal: ExerciseJournal, completionHandler: @escaping (_ isSuccess: Bool) ->()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(EXERCISE_JOURNAL_COLLECTION)
            .getDocuments { (querySnapShot, err) in
                if let err = err {
                    print(err.localizedDescription)
                } else {
                    for document in querySnapShot!.documents {
                        let data = document.data()
                        let id = data["id"] as! String
                        
                        if id == exerciseJournal.id {
                            document.reference.delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                    completionHandler(false)
                                } else {
                                    document.reference
                                        .collection(self.EXERCISE_LIST_COLLECTION)
                                        .getDocuments { (querySnapshot, err) in
                                            for document in querySnapshot!.documents {
                                                document.reference.delete()
                                            }
                                            print("ExerciseJournal Document Successfully removed!")
                                            completionHandler(true)
                                        }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func fetchExerciseJournals(completionHandler: @escaping (_ exerciseJournalArray: [ExerciseJournal]?, _ isSuccess: Bool) -> ()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(EXERCISE_JOURNAL_COLLECTION)
            .getDocuments { (querySnapShot, err) in
                if let err = err {
                    print(err.localizedDescription)
                    completionHandler(nil, false)
                } else {
                    var exerciseJournalArray: [ExerciseJournal] = Array<ExerciseJournal>()
                    if querySnapShot!.documents.isEmpty {
                        completionHandler(nil, false)
                    }
                    
                    for document in querySnapShot!.documents {
                        
                        self.fetchExerciseArray(documentId: document.documentID) { exerciseArray in
                            let data = document.data()
                            let id = data["id"] as! String
                            let title = data["title"] as! String
                            let registerDateTimeStamp = data["registerDate"] as! Timestamp
                            let registerDate = registerDateTimeStamp.dateValue()
                            let startDateTimeStamp = data["startTime"] as! Timestamp
                            let startTime = startDateTimeStamp.dateValue()
                            let endDateTimeStamp = data["endTime"] as! Timestamp
                            let endTime = endDateTimeStamp.dateValue()
                            let totalExerciseTime = data["totalExerciseTime"] as! Int
                            let photoIdArray = data["photoIdArray"] as! [String]
                            let exerciseJournal = ExerciseJournal(id: id,
                                                                  title: title,
                                                                  registerDate: registerDate,
                                                                  startTime: startTime,
                                                                  endTime: endTime,
                                                                  totalExerciseTime: totalExerciseTime,
                                                                  photoIdArray: photoIdArray,
                                                                  exerciseArray: exerciseArray)
                                            
                            exerciseJournalArray.append(exerciseJournal)
                            if self.checkExerciseJournalDone(exerciseJournalArray: exerciseJournalArray, length: querySnapShot!.count) {
                                completionHandler(exerciseJournalArray, true)
                            }
                        }
                    }
                }
            }
    }
    
    private func checkExerciseJournalDone(exerciseJournalArray: [ExerciseJournal], length: Int) -> Bool {
        return exerciseJournalArray.count == length ? true : false
    }
    
    func fetchExerciseArray(documentId: String, completionHandler: @escaping (_ exerciseArray: [Exercise]) -> ()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(EXERCISE_JOURNAL_COLLECTION)
            .document(documentId)
            .collection(EXERCISE_LIST_COLLECTION)
            .order(by: "sequence")
            .getDocuments { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    var exerciseArray: [Exercise] = Array<Exercise>()
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as! String
                        let exerciseName = data["exerciseName"] as! String
                        let exerciseArea = data["exerciseArea"] as! String
                        let exerciseType = data["exerciseType"] as! String
                        let quantityDictArray = data["quantityList"] as! [[String: Any]]
                        var quantityArray: [ExerciseQuantity] = Array<ExerciseQuantity>()
                        quantityDictArray.forEach { quantityDict in
                            let weight = quantityDict["weight"] as! Double
                            let reps = quantityDict["reps"] as! Int
                            quantityArray.append(ExerciseQuantity(weight: weight, reps: reps))
                        }
                        let exercise = Exercise(name: exerciseName,
                                                area: exerciseArea,
                                                quantity: quantityArray,
                                                id: id,
                                                type: exerciseType)
                        
                        exerciseArray.append(exercise)
                    }
                    completionHandler(exerciseArray)
                }
            }
    }
    
    private func getDefaultExercises(completionHandler: @escaping (_ exerciseArray: [Exercise]) -> ()) {
        db.collection(DEFAULT_EXERCISE_COLLECTION)
            .order(by: "sequence", descending: false)
            .getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                var exerciseArray: [Exercise] = Array<Exercise>()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let exerciseName = data["exerciseName"] as! String
                    let exerciseArea = data["exerciseArea"] as! String
                    let id = document.documentID
                    let exercise = Exercise(name: exerciseName,
                                            area: exerciseArea,
                                            quantity: [],
                                            id: id,
                                            type: ExerciseType.basis.rawValue)
                    exerciseArray.append(exercise)
                }
                completionHandler(exerciseArray)
            }
        }
    }
    
    func getUserDefaultExercises(completionHandler: @escaping (_ exerciseArray: [Exercise]) -> ()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(DEFAULT_EXERCISE_COLLECTION)
            .getDocuments { (querySnapshot, error) in
                if let err = error {
                    print(err.localizedDescription)
                } else {
                    var exerciseArray: [Exercise] = Array<Exercise>()
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let exerciseName = data["exerciseName"] as! String
                        let exerciseArea = data["exerciseArea"] as! String
                        let id = data["id"] as! String
                        let exercise = Exercise(name: exerciseName,
                                                area: exerciseArea,
                                                quantity: [],
                                                id: id,
                                                type: ExerciseType.basis.rawValue)
                        exerciseArray.append(exercise)
                    }
                    completionHandler(exerciseArray)
                }
            }
    }
    
    func modifyDefaultExercise(exercise: Exercise, completionHandler: @escaping (_ isSuccess: Bool) -> ()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(DEFAULT_EXERCISE_COLLECTION)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                    completionHandler(false)
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as! String
                        
                        if exercise.id == id {
                            document.reference.updateData([
                                "exerciseName": exercise.name
                            ]) { err in
                                if let err = err {
                                    print(err.localizedDescription)
                                    completionHandler(false)
                                } else {
                                    print("Successfully modifiy default exercise")
                                    completionHandler(true)
                                }
                            }
                        }
                    }
                }
            }
    }
    
    func deleteDefaultExercise(exercise: Exercise, completionHandler: @escaping (_ isSuccess: Bool) -> ()) {
        db.collection(USER_COLLECTION)
            .document(UserDefaultsManager.shared.getDocumentId())
            .collection(DEFAULT_EXERCISE_COLLECTION)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print(err.localizedDescription)
                    completionHandler(false)
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let id = data["id"] as! String
                        
                        if exercise.id == id {
                            document.reference.delete() { err in
                                if let err = err {
                                    print(err.localizedDescription)
                                    completionHandler(false)
                                } else {
                                    print("Successfully delete default exercise")
                                    completionHandler(true)
                                }
                            }
                        }
                    }
                }
            }
    }
}
