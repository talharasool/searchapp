//
//  ViewController.swift
//  searchapp
//
//  Created by talha on 18/11/2021.
//

import UIKit
import RxCocoa
import RxSwift
import UITextView_Placeholder


class SearchViewController: UIViewController {
    
    deinit{print("deintialise")}
    // let loader = APIRequest.shared
    @IBOutlet weak var searchBtn : LoadingButton!
    @IBOutlet weak var searchTxtView: UITextView!
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
}

//MARK:- Life Cycles
extension SearchViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        searchTxtView.becomeFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        searchBtn.layer.cornerRadius = 10
        searchTxtView.layer.cornerRadius = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchViewController{
    
    @IBAction func actionOnSearch(_ sender: Any) {
        self.view.endEditing(true)
        searchBtn.showLoading()
        let query = searchTxtView.text!
        viewModel.fetchResult.onNext((query))
    }
}
//MARK:- Binding
extension SearchViewController{
    
    func bind(){
        _ = searchTxtView.rx.text.map({$0 ?? ""}).bind(to: viewModel.searchText)
        
        
        
        viewModel.searchText.subscribe { [weak self] searchText in
            guard let searchText = searchText.element,
                  let self = self else { return }
            if searchText.isEmptyField{
                self.disableSearchBtn()
            }else{
                self.enableSearchBtn()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.searchData.subscribe { [weak self] searchData in
            guard let searchData = searchData.element,
                  let self = self else { return }
            DispatchQueue.main.async {
                let query = self.searchTxtView.text
                self.searchBtn.hideLoading()
                self.instantiateResultController(searchData,query!)
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.displayError.subscribe { [weak self] error in
            guard let error = error.element,
                  let self = self else { return }
            DispatchQueue.main.async {
                self.searchBtn.hideLoading()
                self.showAlert(message: error)
            }
        }
        .disposed(by: disposeBag)
    }
}

extension SearchViewController{
    
    private func instantiateResultController(_ searchItem : SearchModel,_ query : String){
        let vc = ResultTableViewController.instantiateViewController()
        let viewModel = ResultViewModel(items: searchItem, query: query)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SearchViewController{
    
    func enableSearchBtn(){
        self.searchBtn.isEnabled  = true
    }
    
    func disableSearchBtn(){
        self.searchBtn.isEnabled  = false
    }
}

