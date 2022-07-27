//
//  Extension-UIViewController.swift
//  Reciplease
//
//  Created by Stéphane Rihet on 08/06/2022.
//

import Foundation
import UIKit

extension UIViewController {

    func presentAlert(alert: RecipleaseAlert) {
        let alertVC = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
