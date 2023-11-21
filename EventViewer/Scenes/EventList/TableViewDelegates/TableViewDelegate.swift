//
//  TableViewDelegate.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 09.04.2023.
//

import UIKit

final class TableViewDelegate: NSObject, UITableViewDelegate {

    var onScrollAction: (() -> Void)?
    var onTapCell: ((Int) -> Void)?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
             onScrollAction?()
         }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onTapCell?(indexPath.row)
    }
}
