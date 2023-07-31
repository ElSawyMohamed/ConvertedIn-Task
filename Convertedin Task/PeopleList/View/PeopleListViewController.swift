//
//  PeopleListViewController.swift
//  Convertedin Task
//
//  Created by Mohamed El Sawy on 28/07/2023.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class PeopleListViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var peopleContainerView: UIView!
    @IBOutlet weak var peopleCollectionView: UICollectionView!
    
    let personCollectionViewCell = "PersonCollectionViewCell"
    let peopleListViewModel = PeopleListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindToHiddenTable()
        subscribeToLoading()
        subscribeToResponse()
        subscribeToPersonSelection()
        getPeople()
    }
    func setupCollectionView() {
        peopleCollectionView.register(UINib(nibName: personCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: personCollectionViewCell)
        peopleCollectionView.delegate = self
        peopleCollectionView.prefetchDataSource = self
    }
    func bindToHiddenTable() {
        peopleListViewModel.isCollectionHiddenObservable.bind(to: self.peopleContainerView.rx.isHidden).disposed(by: disposeBag)
    }
    func subscribeToLoading() {
        peopleListViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    func subscribeToResponse() {
        self.peopleListViewModel.peopleModelSubject
            .bind(to: self.peopleCollectionView
                .rx
                .items(cellIdentifier: personCollectionViewCell,
                       cellType: PersonCollectionViewCell.self)) { row, person, cell in
                if person.profilePath?.isEmpty == false {
                    let urlString = "\(NConstants.originalUrl)\(person.profilePath ?? "")"
                    let imgURL = KF.ImageResource(downloadURL: URL(string: urlString)! , cacheKey: urlString)
                    cell.personImage.kf.setImage(with: imgURL)
                } else {
                    cell.personImage.image = UIImage(named: "empty")
                }
                cell.personTitle.text = person.name
                cell.knownFor.text = person.knownForDepartment
                    
            }.disposed(by: disposeBag)
    }
    func subscribeToPersonSelection() {
        Observable
            .zip(peopleCollectionView.rx.itemSelected, peopleCollectionView.rx.modelSelected(Result.self))
            .bind { [weak self] selectedIndex, person in
                guard let self = self else { return }
                let vc = UIStoryboard(name: "PersonDetails", bundle: nil).instantiateViewController(withIdentifier: "PersonDetails") as! PersonDetailsViewController
                vc.personId = person.id
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    func getPeople() {
        peopleListViewModel.getData()
    }
}
// Using DataSource Prefetching For Handling Pagination
extension PeopleListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if index.row >= peopleListViewModel.totalPeople.count - 1 && !peopleListViewModel.isFetchingPeople {
                getPeople()
                break
            }
        }
    }
}
extension PeopleListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/1.0
        return CGSize(width: yourWidth, height: 120)
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
