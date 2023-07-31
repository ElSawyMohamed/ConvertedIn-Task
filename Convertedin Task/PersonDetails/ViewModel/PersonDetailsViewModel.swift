//
//  PersonDetailsViewModel.swift
//  Convertedin Task
//
//  Created by Mohamed El Sawy on 31/07/2023.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class PersonDetailsViewModel {
    
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    var personName = BehaviorRelay<String>(value: "")
    var dateOfBirth = BehaviorRelay<String>(value: "")
    var placeOfBirth = BehaviorRelay<String>(value: "")
    var knownFor = BehaviorRelay<String>(value: "")
        
    private var imagesModelSubject = PublishSubject<[Profile]>()
    private var isCollectionHidden = BehaviorRelay<Bool>(value: false)
    
    var imagesModelObservable: Observable<[Profile]> {
        return imagesModelSubject
    }
    
    var isCollectionHiddenObservable: Observable<Bool> {
        return isCollectionHidden.asObservable()
    }
    
    func getImages(personId: Int) {
        loadingBehavior.accept(true)
        let params = ["api_key": Constants.apiKey] as [String : Any]
        APIService.instance.getData("\(NConstants.person)\(personId)/images" ,ImageList.self ,params, URLEncoding(destination: .methodDependent)) { [weak self] (response, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            if let error = error {
                print(error)
            } else {
                guard let imageModel = response else { return }
                if imageModel.profiles?.count ?? 0 > 0 {
                    self.imagesModelSubject.onNext(imageModel.profiles ?? [])
                    self.isCollectionHidden.accept(false)
                } else {
                    self.isCollectionHidden.accept(true)
                }
            }
        }
    }
    func getBasicData(personId: Int) {
        loadingBehavior.accept(true)
        let params = ["api_key": Constants.apiKey] as [String : Any]
        APIService.instance.getData("\(NConstants.person)\(personId)" ,BasicDetails.self ,params, URLEncoding(destination: .methodDependent)) { [weak self] (response, error) in
            guard let self = self else { return }
            self.loadingBehavior.accept(false)
            if let error = error {
                print(error)
            } else {
                guard let basicDataModel = response else { return }
                self.personName.accept(basicDataModel.name ?? "")
                self.dateOfBirth.accept(basicDataModel.birthday ?? "")
                self.placeOfBirth.accept(basicDataModel.placeOfBirth ?? "")
                self.knownFor.accept(basicDataModel.knownForDepartment ?? "")
            }
        }
    }
}

