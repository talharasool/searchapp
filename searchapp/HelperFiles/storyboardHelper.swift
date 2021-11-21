//
//  storyboardHelper.swift
//  searchapp
//
//  Created by talha on 20/11/2021.
//

import Foundation
import UIKit

protocol StoryboardInitializable {
    
    static var storyboardIdentifier : String{ get }
    static var storyboardName : UIStoryboard.Storyboard {get}
    static func instantiateViewController() -> Self
}


extension UIStoryboard {
    
    enum Storyboard : String {
        case main
        var filename : String {
            return rawValue.capitalized
        }
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
}

extension StoryboardInitializable where Self:UIViewController {
    
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static var storyboardName : UIStoryboard.Storyboard {
        return UIStoryboard.Storyboard.main
    }
    
    static func instantiateViewController() -> Self{
        let storyboard = UIStoryboard.storyboard(storyboard: storyboardName)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
    
}
