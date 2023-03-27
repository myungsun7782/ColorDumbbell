//
//  DetailJournalPhotoCell.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/24.
//

import UIKit

class DetailJournalPhotoCell: UITableViewCell {
    // UICollectionView
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // Variables
    var photoIdList: [String] = Array<String>()
    var detailExerciseJournalVC: DetailExerciseJournalVC?
    
    // Constants
    let COLLECTION_VIEW_MINIMUM_SPACING: CGFloat = 8
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    private func initUI() {
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        registerCollectionViewCell()
    }
    
    private func registerCollectionViewCell() {
        photoCollectionView.register(UINib(nibName: Cell.photoCell, bundle: nil), forCellWithReuseIdentifier: Cell.photoCell)
    }
    
    func setData(photoIdList: [String], detailExerciseJournalVC: DetailExerciseJournalVC) {
        self.photoIdList = photoIdList
        self.detailExerciseJournalVC = detailExerciseJournalVC
        photoCollectionView.reloadData()
    }
    
    private func presentDetailImageVC(index: Int) {
        if let detailExerciseJournalVC = detailExerciseJournalVC {
            let detailImageVC = UIStoryboard(name: Storyboard.main, bundle: nil).instantiateViewController(withIdentifier: VC.detailImageVC) as! DetailImageVC
            
            detailImageVC.photoId = photoIdList[index]
            detailImageVC.modalPresentationStyle = .overCurrentContext
            detailImageVC.modalTransitionStyle = .crossDissolve
            
            detailExerciseJournalVC.present(detailImageVC, animated: true)
        }
    }
}

extension DetailJournalPhotoCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoIdList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.photoCell, for: indexPath) as! PhotoCell
        
        cell.photoImageView.fetchImage(photoId: photoIdList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return COLLECTION_VIEW_MINIMUM_SPACING
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentDetailImageVC(index: indexPath.row)
    }
}
