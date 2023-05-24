//
//  DumbbellCriteriaVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/04/16.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class DumbbellCriteriaVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    // UITableView
    @IBOutlet weak var criteriaTableView: UITableView!
    
    // UIStackView
    @IBOutlet weak var backButtonStackView: UIStackView!
    
    // UIButton
    @IBOutlet weak var backButton: UIButton!
    
    // ViewModel
    let viewModel = DumbbellCriteriaVM()
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Constants
    let BACK_BUTTON_IMAGE: UIImage? = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
    }
    
    private func initUI() {
        // UIButton
        configureButton()
        
        // UITableView
        configureTableView()
    }
    
    private func action() {
        backButtonStackView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.setImage(BACK_BUTTON_IMAGE, for: .normal)
    }
    
    private func configureTableView() {
        criteriaTableView.dataSource = self
        criteriaTableView.delegate = self
        registerTableViewCell()
    }
    
    private func registerTableViewCell() {
        criteriaTableView.register(UINib(nibName: Cell.dumbbellCriteriaCell, bundle: nil), forCellReuseIdentifier: Cell.dumbbellCriteriaCell)
    }
}

extension DumbbellCriteriaVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.levelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.dumbbellCriteriaCell) as! DumbbellCriteriaCell
        
        cell.setData(level: viewModel.levelArray[indexPath.row])
        
        return cell
    }
    
    
}
