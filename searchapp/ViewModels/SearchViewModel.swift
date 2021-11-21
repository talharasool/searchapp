//
//  SearchViewModel.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class SearchViewModel {
    
    let disposeBag = DisposeBag()
    let loader = APIRequest.shared
    
    var searchText : BehaviorRelay<String> = BehaviorRelay(value: "")
    public var searchData : PublishSubject<SearchModel> = PublishSubject()
    public var loading: PublishSubject<Bool> = PublishSubject()
    let fetchResult = PublishSubject<String>()
    let displayError = PublishSubject<String>()
    
    init() {
        bind()
    }
}


extension SearchViewModel{
    
    private func bind() {

        fetchResult.subscribe { [weak self] event in
            guard let self = self , let query = event.element else { return }
            self.fetchDataFromServer(query: query)
        }
        .disposed(by: disposeBag)
    }
    
    private func fetchDataFromServer(query  : String){
    
        loader.fetchResult(target: .searchComponents(login: query, page: 1)) { [weak self] (model : SearchModel) in
            guard let self = self else { return }
            if model.total_count == 0{
                self.displayError.onNext("Login not found")
            }else{
                self.searchData.onNext(model)
            }
        } failure: {[weak self]  error in
            guard let self = self else { return }
            switch error{
            case .httpError(let err):
                self.displayError.onNext(err)
            case .other(let err):
                self.displayError.onNext(err)
            case .Invalid_JSON(let err):
                self.displayError.onNext(err)
            case .Limit_Reaced(let err):
                self.displayError.onNext(err)
            }
        }

    }
    
}
