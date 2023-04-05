//
//  DetailImageVC.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/20.
//

import UIKit
import RxSwift
import RxCocoa

class DetailImageVC: UIViewController {
    // UIStatusBarStyle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // UIView
    @IBOutlet weak var containerView: UIView!
    
    // UIImageView
    @IBOutlet weak var detailImageView: UIImageView!
    
    // UIButton
    @IBOutlet weak var closeButton: UIButton!
    
    // UIImage
    var selectedImage: UIImage?
    var photoId: String?
    
    // RxSwift
    let disposeBag = DisposeBag()
    
    // Variables
    
    // Constants
    let BUTTON_IMAGE: UIImage? = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23))
    let PINCH_GESTURE_SCALE: CGFloat = 1.0
    let ANIMATION_DURATION: CGFloat = 0.3
    let CONTAINER_VIEW_ALPHA: CGFloat = 0.7
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        action()
    }
    
    private func initUI() {
        // UIView
        configureView()
        
        // UIImageView
        configureImageView()
        initImageViewFromStorage()
        
        // UIButton
        configureButton()
    }
    
    private func action() {
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureView() {
        // MARK: - alpha값 설정
        containerView.alpha = CONTAINER_VIEW_ALPHA
    }
    
    private func configureImageView() {
        guard let selectedImage = selectedImage else { return }
        detailImageView.image = selectedImage
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(pinchGesture:)))
        detailImageView.isUserInteractionEnabled = true
        detailImageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    private func initImageViewFromStorage() {
        guard let photoId = photoId else { return }
        detailImageView.fetchImage(photoId: photoId)
    
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(pinchGesture:)))
        detailImageView.isUserInteractionEnabled = true
        detailImageView.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func handlePinch(pinchGesture: UIPinchGestureRecognizer) {
        if pinchGesture.state == .began || pinchGesture.state == .changed {
            detailImageView.transform = detailImageView.transform.scaledBy(x: pinchGesture.scale, y: pinchGesture.scale)
            pinchGesture.scale = PINCH_GESTURE_SCALE
        } else if pinchGesture.state == .ended {
            UIView.animate(withDuration: ANIMATION_DURATION) {
                self.detailImageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    private func configureButton() {
        closeButton.setImage(BUTTON_IMAGE, for: .normal)
    }
}
