//
//  DetailEventDataSource.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 17.04.2023.
//

import UIKit

final class DetailEventDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: DetailEventModelProtocol!
    var indexCell: Int!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return viewModel.entityEvent?.parameter != nil ? 4 : 1
        default:
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: DetailTableViewCell.identifier,
            for: indexPath) as? DetailTableViewCell else { fatalError("DetailCell nil") }
        
        cell.selectionStyle = .none
        
        cell.textView.tag = indexPath.row
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = viewModel.entityEvent?.id
            
        case 1:
            cell.titleLabel.text = viewModel.entityEvent?.date
            
        case 2:
            cell.resetConstraint()
            
            if viewModel.entityEvent?.parameter != nil {
                cell.titleLabel.text = viewModel.titlesParameter[indexPath.row]
                
                switch cell.textView.tag {
                case 0: cell.textView.text = viewModel.entityEvent?.parameter?.key
                case 1: cell.textView.text = viewModel.entityEvent?.parameter?.string
                case 2: cell.textView.text = viewModel.entityEvent?.parameter?.int
                case 3: cell.textView.text = viewModel.entityEvent?.parameter?.bool
                default:
                    break
                }
                
            }  else {
                
                cell.hideParameters()
                
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = viewModel.titlesSection[section]
        return section
    }
}
