//
//  TableViewDataSource.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 09.04.2023.
//

import UIKit

final class TableViewDataSource: NSObject, UITableViewDataSource {
    
    var viewModel: EventListModelProtorol!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.limitAllEvents.isEmpty {
            return 1
        } else {
            return viewModel.limitAllEvents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { fatalError("Cell nil") }
        
        cell.titleLabel.text = viewModel.eventID(index: indexPath.row)
        cell.subtitleLabel.text = viewModel.eventDate(index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.row > 0 {
            if editingStyle == .delete {
                viewModel.deleteEvent(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .top)
                tableView.reloadData()
            }
        } else {
            viewModel.deleteEvent(index: indexPath.row)
            tableView.reloadData()
        }
      }
    
}
