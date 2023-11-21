//
//  File.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 26.04.2023.
//

import UIKit

extension UIViewController {

   func hideKeyboard() {
       let endEditingTapRecognizer = UITapGestureRecognizer(
           target: view,
           action: #selector(UIView.endEditing)
       )
       view.addGestureRecognizer(endEditingTapRecognizer)
   }
}
