//
//  PersonDetailsViewController.swift
//  Convertedin Task
//
//  Created by Mohamed El Sawy on 31/07/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PersonDetailsViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var imagesContainerView: UIView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var placeOfBirth: UILabel!
    @IBOutlet weak var knownFor: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var personId: Int = 0
    let imageCollectionViewCell = "ImageCollectionViewCell"
    let personDetailsViewModel = PersonDetailsViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindToHiddenTable()
        subscribeToLoading()
        subscribeToImagesResponse()
        subscribeToBasicDtsResponse()
        subscribeToPhotoSelection()
        getImages()
        getBasicData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = imagesCollectionView.collectionViewLayout.collectionViewContentSize.height
        collectionViewHeight.constant = height
        self.view.layoutIfNeeded()
    }
    func setupCollectionView() {
        imagesCollectionView.register(UINib(nibName: imageCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: imageCollectionViewCell)
        imagesCollectionView.delegate = self
    }
    func bindToHiddenTable() {
        personDetailsViewModel.isCollectionHiddenObservable.bind(to: self.imagesContainerView.rx.isHidden).disposed(by: disposeBag)
    }
    func subscribeToLoading() {
        personDetailsViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    func subscribeToImagesResponse() {
        self.personDetailsViewModel.imagesModelObservable
            .bind(to: self.imagesCollectionView
                .rx
                .items(cellIdentifier: imageCollectionViewCell,
                       cellType: ImageCollectionViewCell.self)) { row, profile, cell in
                if profile.filePath.isEmpty == false {
                    let urlString = "\(NConstants.originalUrl)\(profile.filePath)"
                    let imgURL = KF.ImageResource(downloadURL: URL(string: urlString)! , cacheKey: urlString)
                    cell.personImage.kf.setImage(with: imgURL)
                } else {
                    cell.personImage.image = UIImage(named: "empty")
                }
                    
            }.disposed(by: disposeBag)
    }
    func subscribeToPhotoSelection() {
        Observable
            .zip(imagesCollectionView.rx.itemSelected, imagesCollectionView.rx.modelSelected(Profile.self))
            .bind { [weak self] selectedIndex, photo in
                guard let self = self else { return }
                let urlString = "\(NConstants.originalUrl)\(photo.filePath)"
                let vc = PhotoViewerViewController(with: URL(string: urlString)!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    func subscribeToBasicDtsResponse() {
        personDetailsViewModel.personName.subscribe(onNext: { (personName) in
            self.personName.text = personName
        }).disposed(by: disposeBag)
        
        personDetailsViewModel.dateOfBirth.subscribe(onNext: { (dateOfBirth) in
            self.dateOfBirth.text = dateOfBirth

        }).disposed(by: disposeBag)
        
        personDetailsViewModel.placeOfBirth.subscribe(onNext: { (placeOfBirth) in
            self.placeOfBirth.text = placeOfBirth

        }).disposed(by: disposeBag)
        
        personDetailsViewModel.knownFor.subscribe(onNext: { (knownFor) in
            self.knownFor.text = knownFor

        }).disposed(by: disposeBag)
    }
    func getImages() {
        personDetailsViewModel.getImages(personId: personId)
    }
    func getBasicData() {
        personDetailsViewModel.getBasicData(personId: personId)
    }
}
extension PersonDetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 5) - 5), height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
