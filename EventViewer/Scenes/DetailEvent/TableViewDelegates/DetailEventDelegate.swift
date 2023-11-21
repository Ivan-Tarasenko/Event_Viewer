//
//  DetailEventDelegate.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 17.04.2023.
//

import UIKit

final class DetailEventDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let titleSection = view as! UITableViewHeaderFooterView
        titleSection.textLabel?.text =  titleSection.textLabel?.text?.capitalized
    }
}
