//
//  TableViewCell.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 10.04.2023.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let titleLabel = UILabel()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TableViewCell {
    
    func addSubview() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    func addConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.leading.trailing.equalTo(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(30)
            make.leading.trailing.equalTo(20)
        }
    }
}

