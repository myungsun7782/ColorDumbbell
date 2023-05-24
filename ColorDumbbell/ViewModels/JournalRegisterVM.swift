//
//  JournalRegisterVM.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/11.
//

import Foundation
import RxSwift
import Photos
import YPImagePicker

class JournalRegisterVM {
    // Input
    var input = Input()
    
    // Output
    var output = Output()
    
    // Variable
    var photoAndIdList = Array<(UIImage, String)>()
    var exerciseArray: [Exercise] = Array<Exercise>()
    var journalRegisterVC: JournalRegisterVC?
    var section: Int?
    var row: Int?
    var weight: Double?
    var reps: Int?
    var startTime: Date?
    var endTime: Date?
    var title: String?
    var totalExerciseTime: Int = 1
    var delegate: ExerciseJournalDelegate?
    var editorMode: EditorMode = .new
    var exerciseJournal: ExerciseJournal?
    var exerciseJournalArray: [ExerciseJournal]?
    lazy var isEditingMode: Bool = editorMode == .new ? false : true
    
    // Constants
    let MAX_NUMBER_OF_PHOTO: Int = 3
    let MAX_TITLE_LENGTH: Int = 15
    let ALERT_TITLE: String = "사진은 최대 3장까지 등록할 수 있습니다."
    let ACTION_TITLE: String = "확인"
    let WEIGHT_DEFAULT_VALUE: String = "0"
    let WEIGHT_MAXIMUM_VALUE: String = "999.9"
    let REPS_DEFAULT_VALUE: String = "0"
    let REPS_MAXIMUM_VALUE: String = "9999"
    let WEIGHT_BUTTON_VALUE_ARRAY: [Double] = [-5.0, -1.0, 1.0, 5.0]
    let REPS_BUTTON_VALUE_ARRAY: [Int] = [-5, -1, 1, 5]
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    struct Input {
        var selectedSection = PublishSubject<Int>()
        var selectedRow = PublishSubject<Int>()
    }
    
    struct Output {
    }
    
    init() {
        Observable.combineLatest(input.selectedSection, input.selectedRow)
            .subscribe(onNext: { (section, row) in
                self.section = section
                self.row = row
            })
            .disposed(by: disposeBag)
    }
    
    func validateTime(startTime: Date, endTime: Date) -> Bool {
        if startTime > endTime {
            return false
        }
        return true
    }
    
    func presentImagePicker(journalRegisterVC: JournalRegisterVC) {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = MAX_NUMBER_OF_PHOTO - photoAndIdList.count
        config.library.mediaType = .photo
        config.screens = [.library]
        config.showsPhotoFilters = false
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    self.photoAndIdList.append((photo.image, UUID().uuidString))
                case .video(_):
                    continue
                }
            }
            
            picker.dismiss(animated: true) {
                DispatchQueue.main.async {
                    journalRegisterVC.journalTableView.reloadData()
                }
            }
        }
        journalRegisterVC.present(picker, animated: true, completion: nil)
    }
    
    func presentPhotoMaxAlert(journalRegisterVC: JournalRegisterVC) {
        // TODO: Show alert
        let alert = UIAlertController(title: nil, message: ALERT_TITLE, preferredStyle: .alert)
        let confirmButton = UIAlertAction(title: ACTION_TITLE, style: .default)
        alert.addAction(confirmButton)
        journalRegisterVC.present(alert, animated: true, completion: nil)
    }
    
    func validateButton(journalRegisterVC: JournalRegisterVC, title: String, exerciseArray: [Exercise]) -> Bool {
        if title.isEmpty {
            AlertManager.shared.presentOneButtonAlert(title: "운동 일지를 등록할 수 없음", message: "운동 일지 제목을 작성해주세요.") {
            } completionHandler: { alert in
                journalRegisterVC.present(alert, animated: true, completion: nil)
            }
            
            return false
        } else if exerciseArray.isEmpty {
            AlertManager.shared.presentOneButtonAlert(title: "운동 일지를 등록할 수 없음", message: "운동을 추가한 뒤 기록해주세요.") {
            } completionHandler: { alert in
                journalRegisterVC.present(alert, animated: true, completion: nil)
            }
            
            return false
        } else if !exerciseArray.isEmpty {
            for exercise in exerciseArray {
                for exercicseQuantity in exercise.quantity {
                    if exercicseQuantity.reps == .zero {
                        AlertManager.shared.presentOneButtonAlert(title: "운동 일지를 등록할 수 없음", message: "아직 수행하지 않은 운동이 있습니다.") {
                        } completionHandler: { alert in
                            journalRegisterVC.present(alert, animated: true, completion: nil)
                        }
                        return false
                    }
                }
            }
        } else if let exerciseJournalArray = exerciseJournalArray, let startTime = startTime {
            for journal in exerciseJournalArray {
                if TimeManager.shared.dateToString(date: journal.startTime, options: [.year, .month, .day]) == TimeManager.shared.dateToString(date: startTime, options: [.year, .month, .day]) {
                    AlertManager.shared.presentOneButtonAlert(title: "운동 일지를 등록할 수 없음", message: "해당 날짜는 이미 등록된 운동 일지가 있습니다.") {
                    } completionHandler: { alert in
                        journalRegisterVC.present(alert, animated: true, completion: nil)
                    }
                    return false
                }
            }
        } else {
            var isRegistered = false
            for exercise in exerciseArray {
                if exercise.quantity.isEmpty {
                    isRegistered = false
                    break
                } else {
                    isRegistered = true
                }
            }
            if !isRegistered {
                AlertManager.shared.presentOneButtonAlert(title: "운동 일지를 등록할 수 없음", message: "세트를 추가해서 기록해주세요.") {
                } completionHandler: { alert in
                    journalRegisterVC.present(alert, animated: true, completion: nil)
                }
                
                return false
            }
        }
        return true
    }
    
    func getPhotoIdArray() -> [String] {
        var photoIdArray: [String] = Array<String>()
        
        for photoAndId in photoAndIdList {
            photoIdArray.append(photoAndId.1)
        }
        
        return photoIdArray
    }
    
    func fetchPhotos(journalRegisterVC: JournalRegisterVC) {
        if editorMode == .edit {
            if let exerciseJournal = exerciseJournal, !exerciseJournal.photoIdArray!.isEmpty {
                LoadingManager.shared.showLoading()
                FirebaseManager.shared.downloadImagese(fileNameList: exerciseJournal.photoIdArray!) { photoAndIdList in
                    self.photoAndIdList = photoAndIdList
                    DispatchQueue.main.async {
                        journalRegisterVC.journalTableView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            LoadingManager.shared.hideLoading()
                        }
                    }
                }
            }
        }
    }
}
