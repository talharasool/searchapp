//
//  ResultTableViewCell.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//

import UIKit
import Kingfisher

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImgView : UIImageView!
    @IBOutlet weak var informationLbl : UILabel!
    
    var item : SearchData!{
        didSet{
            self.updateUI()
        }
    }
    
}

extension ResultTableViewCell{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        informationLbl.numberOfLines = 0
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension ResultTableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        avatarImgView.layer.cornerRadius = 10
    }
}

extension ResultTableViewCell{
    
    private func updateUI(){
        informationLbl.attributedText = NSAttributedString().setResultInformationToLbl(login: item.login, type: item.type)
        setImage(with: item.avatar_url)
    }
    
    private func setImage(with string : String){
        avatarImgView.kf.indicatorType = .activity
        if let url = URL(string: string){
            avatarImgView.kf.setImage(with: url)
        }
        
    }
}
