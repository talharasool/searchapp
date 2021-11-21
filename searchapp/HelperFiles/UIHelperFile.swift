//
//  UIHelperFile.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//

import Foundation
import UIKit

extension UITableView{
    func configureSetting(){
        backgroundColor = .white
        let nib = UINib(nibName: "ResultTableViewCell", bundle: nil)
        register(nib, forCellReuseIdentifier: "ResultTableViewCell")
        //estimatedRowHeight = 1
        rowHeight = UITableView.automaticDimension
        refreshControl = refreshControl
        tableFooterView = UIView(frame: .zero)
        delegate = nil
        dataSource = nil
        
    }
}

extension UIViewController{
    
    func showAlert(message : String){
        
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - String 
extension NSAttributedString{
    
    func setResultInformationToLbl(login : String,  type : String) -> NSAttributedString {
    
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 12
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold) , NSAttributedString.Key.foregroundColor : UIColor.black]
        let loginString = NSMutableAttributedString(string: login, attributes: myAttribute )
        
        let typeString = NSAttributedString(string: "\n" + type, attributes:  [ NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 18, weight: .medium) , NSAttributedString.Key.foregroundColor : UIColor.gray.withAlphaComponent(0.7)])
        
        loginString.append(typeString)
        loginString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, loginString.length))
        
        return  loginString
    }
}

extension StringProtocol where Index == String.Index {
    var isEmptyField: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
