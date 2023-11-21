//
//  AuxiliaryFunctions.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 20.04.2023.
//

import UIKit

final class AuxiliaryFunctions {
    
    static let shared = AuxiliaryFunctions()
    
   private init() {}
    
    func animation(cell: UITableViewCell) {
        UIView.animate(withDuration: 0.1, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.94, y: 0.94)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform.identity
            })
        })
    }
    
    func showAlert(on view: UIViewController, title: String, massage: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.delegate = view as? any UITextFieldDelegate
            textField.autocapitalizationType = .allCharacters
            textField.keyboardType = .asciiCapable
            textField.placeholder = "Enter ..."
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let create = UIAlertAction(title: "Create", style: .default) { action in
            guard let textField = alert.textFields?.first, let saveText = textField.text else { return }
            completion(saveText)
        }

        alert.addAction(cancel)
        alert.addAction(create)
        view.present(alert, animated: true)
    }
    
    func showAlertClear(on view: UIViewController, title: String, massage: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .default)
        let create = UIAlertAction(title: "Clear", style: .default) { action in
            completion()
        }

        alert.addAction(cancel)
        alert.addAction(create)
        view.present(alert, animated: true)
    }
    
}
