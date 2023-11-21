//
//  DateView.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 26.04.2023.
//

import UIKit
import SnapKit

final class DateView: UIView {
    
    var onActionOkButton: ((Date) -> Void)?
    
    let datePicker = UIDatePicker()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configerationView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension DateView {
    
    func addSubviews() {
        addSubview(datePicker)
        addSubview(okButton)
    }
    
    func configerationView() {
        self.isHidden = true
        okButton.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
    }
    
    func addConstraints() {
        
        datePicker.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-9)
        }
        
        okButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(datePicker).offset(40)
            make.width.equalTo(36)
            make.height.equalTo(36)
        }
    }
    
    @objc
    private func okButtonPressed() {
        onActionOkButton?(datePicker.date)
    }
}
