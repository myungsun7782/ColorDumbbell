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
    private let storageUrl = "gs://colordumbbell.appspot.com/"
    private init() {}
    
    func uploadImage(photoAndIdList: Array<(UIImage, String)>, completionHandler: @escaping (_ photoIdList: Array<String>) -> ()) {
        var photoIdList = Array<(String, Bool)>()
        
        for (idx, _) in photoAndIdList.enumerated() {
            photoIdList.append((photoAndIdList[idx].1, false))
        }
        
        for (idx, _) in photoAndIdList.enumerated() {
            var data = Data()
            data = photoAndIdList[idx].0.jpegData(compressionQuality: 0.8)!
            
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
