//
//  ResultViewModel.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//
import Foundation
import RxSwift
import RxCocoa
import UIKit

class ResultViewModel {
    
    let disposeBag = DisposeBag()
    let loader = APIRequest.shared
    let items : BehaviorRelay<[SearchData]> =   BehaviorRelay(value: [])
    let fetchMoreDatas = PublishSubject<Void>()
    let isLoadingSpinnerAvaliable = PublishSubject<Bool>()
    let displayError = PublishSubject<String>()
    
    private var query : String!
    private var pageCounter = 2
    private var maxValue = 1
    private var isPaginationRequestStillResume = false

    
    init(items : SearchModel, query : String ) {
        self.maxValue = items.total_count
        self.query = query
        self.items.accept(items.items)
    }
    
}

extension ResultViewModel{
    
    func bind() {
        
        fetchMoreDatas.subscribe { [weak self] _ in
            guard let self = self else { return }
            self.fetchDummyData(page: self.pageCounter,
                                isRefreshControl: false)
        }
        .disposed(by: disposeBag)
        
        
    }
    
    private func fetchDummyData(page: Int, isRefreshControl: Bool) {
        
        //print(isPaginationRequestStillResume,isRefreshRequstStillResume)
        if isPaginationRequestStillResume  { return }
        
        
        if pageCounter > maxValue  {
            isPaginationRequestStillResume = false
            return
        }
        
        isPaginationRequestStillResume = true
        isLoadingSpinnerAvaliable.onNext(true)
        
        if pageCounter == 1  || isRefreshControl {
            isLoadingSpinnerAvaliable.onNext(false)
        }
        
        print("the page is here",UInt(page))
        loader.fetchResult(target: .searchComponents(login: query, page: UInt(page))) { [weak self] (model : SearchModel) in
            guard let self = self else { return }
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
            
            if model.total_count == 0{
                self.displayError.onNext("Login not found")
            }else{
                let items = (self.items.value + model.items).sorted(by: { $0 < $1})
                self.items.accept(items)
                self.pageCounter += 1
            }

        } failure: {[weak self]  error in
            guard let self = self else { return }
            self.isLoadingSpinnerAvaliable.onNext(false)
            self.isPaginationRequestStillResume = false
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
