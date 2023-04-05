//
//  RoutineVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class RoutineVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // UIStackView
    @IBOutlet weak var emptyStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var addButton: UIButton!
    
    // UITableView
    @IBOutlet weak var routineTableView: UITableView!
    
    // ViewModel
    let viewModel = RoutineVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variables
    
    // Constants
    let ADD_BUTTON_IMAGE: UIImage? = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
        bind()
        viewModel.fetchRoutines()
    }
    
    private func initUI() {
        // UIStackView
        configureStackView()
        
        // UIButton
        configureButton()
        
        // UITableView
        configureTableView()
    }
    
    private func action() {
        // UIButton
        addButton.rx.tap
            .subscribe(onNext: { _ in
                self.presentRoutineRegisterVC(editorMode: .new)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bind() {
        // Output
        viewModel.output
            .fetchDataDone
            .subscribe(onNext: { _ in
                LoadingManager.shared.hideLoading()
                self.configureStackView()
                DispatchQueue.main.async {
                    self.routineTableView.reloadData()
                }
        })
        .disposed(by: disposeBag)
    }
    
    private func configureStackView() {
        emptyStackView.isHidden = viewModel.routineArray.isEmpty ? false : true
    }
    
    private func configureButton() {
        addButton.setImage(ADD_BUTTON_IMAGE, for: .normal)
    }
    
    private func configureTableView() {
        routineTableView.dataSource = self
        routineTableView.delegate = self
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        routineTableView.register(UINib(nibName: Cell.routineTitleCell, bundle: nil), forCellReuseIdentifier: Cell.routineTitleCell)
        routineTableView.register(UINib(nibName: Cell.routineContentCell, bundle: nil), forCellReuseIdentifier: Cell.routineContentCell)
    }
    
    private func presentRoutineRegisterVC(section: Int? = nil, modifiableRoutine: Routine? = nil, editorMode: EditorMode) {
        let routineRegisterVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.routineRegisterVC) as! RoutineRegisterVC
        
        routineRegisterVC.viewModel.delegate = self
        routineRegisterVC.viewModel.modifiableRoutine = modifiableRoutine
        routineRegisterVC.viewModel.title = modifiableRoutine?.name
        routineRegisterVC.viewModel.memo = modifiableRoutine?.memo
        routineRegisterVC.viewModel.exerciseArray = modifiableRoutine?.exerciseArray ?? []
        routineRegisterVC.viewModel.section = section
        routineRegisterVC.viewModel.editorMode = editorMode
        
        present(routineRegisterVC, animated: true)
    }
}

extension RoutineVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.routineArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.routineArray[section].exerciseArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.routineTitleCell) as! RoutineTitleCell
            
            cell.setData(name: viewModel.routineArray[indexPath.section].name,
                        index: indexPath.section)
            
            cell.deleteButton.rx.tap
                .subscribe(onNext: { _ in
                    AlertManager.shared.presentTwoButtonAlert(title: "삭제", message: "정말로 해당 루틴을 삭제하시겠습니까?", buttonTitle: "확인", style: .alert) {
                        FirebaseManager.shared.deleteRoutine(routine: self.viewModel.routineArray[indexPath.section]) { isSuccess in
                            self.viewModel.routineArray.remove(at: indexPath.section)
                            self.configureStackView()
                            DispatchQueue.main.async {
                                self.routineTableView.reloadData()
                            }
                        }
                    } completionHandler: { alert in
                        self.present(alert, animated: true)
                    }
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.routineContentCell) as! RoutineContentCell
        
        // MARK: - 유저의 현재 레벨 단계의 색깔로 수정해주기
        cell.setData(currentLevelColor: ColorManager.shared.getCyclamen(),
                     exerciseName: viewModel.routineArray[indexPath.section].exerciseArray[indexPath.row-1].name,
                    exerciseSet: viewModel.routineArray[indexPath.section].exerciseArray[indexPath.row-1].quantity.count,
                    index: indexPath.row-1,
                    lastIndex: viewModel.routineArray[indexPath.section].exerciseArray.count - 1)
        
        cell.containerStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.presentRoutineRegisterVC(section: indexPath.section,
                                              modifiableRoutine: self.viewModel.routineArray[indexPath.section],
                                              editorMode: .edit)
            })
            .disposed(by: cell.disposeBag)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section), row: \(indexPath.row)")
    }
}

extension RoutineVC: ExerciseRoutineDelegate {
    func transferData(section: Int?, routine: Routine, editorMode: EditorMode) {
        if editorMode == .new {
            viewModel.routineArray.append(routine)
        } else if editorMode == .edit {
            guard let section = section else { return }
            viewModel.routineArray[section] = routine
        }
        configureStackView()
        routineTableView.reloadData()
    }
}
