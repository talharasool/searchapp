//
//  ResultTableViewController.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ResultTableViewController: UITableViewController {
    
    deinit{print("Deinitalize Controller")}
    
    var viewModel : ResultViewModel! = nil
    private let disposeBag = DisposeBag()
    public var searchData : PublishSubject<[SearchData]> = PublishSubject()
    private lazy var viewSpinner: UIView = {
        let view = UIView(frame: CGRect(x: 0,y: 0,width: view.frame.size.width,height: 100)
        )
        let spinner = UIActivityIndicatorView()
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.configureSetting()
        bind()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.bind()
    }
    
    
    @IBAction func actionOnBackBtn(_ sender : Any){
        self.navigationController?.popViewController(animated: true)
    }
    private func bind() {
        
        tableViewBind()
        
        viewModel.isLoadingSpinnerAvaliable.subscribe { [weak self] isAvaliable in
            guard let isAvaliable = isAvaliable.element,
                  let self = self else { return }
            self.tableView.tableFooterView = isAvaliable ? self.viewSpinner : UIView(frame: .zero)
        }
        .disposed(by: disposeBag)
        
        viewModel.displayError.subscribe { [weak self] error in
            guard let error = error.element,
                  let self = self else { return }
            
            DispatchQueue.main.async {
                self.showAlert(message: error)
            }
        }
        .disposed(by: disposeBag)
    }
    
    
}

extension ResultTableViewController{
    
    
    private func tableViewBind() {
        
        viewModel.items.bind(to: tableView.rx.items) { tableView, _, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell") as! ResultTableViewCell
            cell.selectionStyle = .none
            cell.item = item
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.tableView.contentOffset.y
            let contentHeight = self.tableView.contentSize.height
            
            if offSetY > (contentHeight - self.tableView.frame.size.height - 100) {
                self.viewModel.fetchMoreDatas.onNext(())
            }
        }
        .disposed(by: disposeBag)
    }
}

extension ResultTableViewController{
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension ResultTableViewController : StoryboardInitializable{}


