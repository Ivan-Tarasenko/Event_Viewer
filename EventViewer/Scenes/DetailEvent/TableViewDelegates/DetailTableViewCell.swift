//
//  DetailTableViewCell.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 17.04.2023.
//

import UIKit
import SnapKit

final class DetailTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func resetConstraint() {
        
        titleLabel.snp.removeConstraints()
        
        contentView.addSubview(textView)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(10)
        }
        
        textView.snp.makeConstraints { make in
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(160)
            make.height.equalTo(35)
            make.trailing.equalTo(-10)
        }
    }
    
    func hideParameters() {
        textView.backgroundColor = .blue
        textView.removeFromSuperview()
        titleLabel.text = R.ErrorTitle.noParameter
        
        titleLabel.snp.removeConstraints()
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
    }
}

// MARK: - Private function
private extension DetailTableViewCell {
    
    func addSubview() {
        contentView.addSubview(titleLabel)
        
    }
    
    func addConstraint() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
