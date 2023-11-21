//
//  AddEventDelegate.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 20.04.2023.
//

import UIKit

final class AddEventDelegate: NSObject, UITableViewDelegate {
    
    let auxiliaryFunctions = AuxiliaryFunctions.shared
    
    var onTapCell: ((Int, Int) -> Void)?
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let titleSection = view as! UITableViewHeaderFooterView
        titleSection.textLabel?.text =  titleSection.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0, 1:
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            auxiliaryFunctions.animation(cell: cell)
        default:
            break
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
        onTapCell?(indexPath.section, indexPath.row)
    }
}

