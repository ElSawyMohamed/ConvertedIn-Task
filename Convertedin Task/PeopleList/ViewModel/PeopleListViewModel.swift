//
//  PeopleListViewModel.swift
//  ConvertedinTask
//
//  Created by Mohamed El Sawy on 29/07/2023.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class PeopleListViewModel {
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var isCollectionHidden = BehaviorRelay<Bool>(value: false)
    var peopleModelSubject = BehaviorRelay<[Result]>(value: [])
    
    private var currentPage = 1
    var isFetchingPeople = false
    var totalPeople = [Result]()
    
    var isCollectionHiddenObservable: Observable<Bool> {
        return isCollectionHidden.asObservable()
    }

    func getData() {
        isFetchingPeople = true
        loadingBehavior.accept(true)
        let params = ["api_key": Constants.apiKey, "page": currentPage] as [String : Any]
        APIService.instance.getData(NConstants.popularPeople ,PeopleList.self ,params, URLEncoding(destination: .methodDependent)) { [weak self] (response, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            print("🚀 Call Page number : \(self.currentPage)")
            if let error = error {
                print(error)
            } else {
                guard let peopleModel = response else { return }
                if peopleModel.results?.count ?? 0 > 0 {
                    self.totalPeople = peopleModel.results ?? []
                    self.peopleModelSubject.accept(self.peopleModelSubject.value + (peopleModel.results  ?? []))
                    self.isCollectionHidden.accept(false)
                } else {
                    self.isCollectionHidden.accept(true)
                }
            }
            // For Handling Pagination
            self.currentPage += 1
            self.isFetchingPeople = false
        }
    }
}
