//
//  AddEventTableViewCell.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 20.04.2023.
//

import UIKit
import SnapKit

final class AddEventTableViewCell: UITableViewCell {
    
    var onDate: ((Date) -> Void)?
    var onKey: ((String?) -> Void)?
    var onString: ((String?) -> Void)?
    var onInt: ((Int?) -> Void)?
    var onBool: ((Bool?) -> Void)?
    
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
        textView.returnKeyType = .done
        return textView
    }()
    
    lazy var dateView = DateView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuratonCell()
        addSubview()
        addConstraint()
        setDate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDate() {
        dateView.onActionOkButton = { [weak self] date in
            guard let self else { return }
            self.dateView.isHidden = true
            self.titleLabel.text = self.convertDate(from: date)
            self.onDate?(date)
        }
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
    
    func setLowercaseLetter() {
        switch textView.tag {
        case 0: textView.autocapitalizationType = .allCharacters
        case 2: textView.keyboardType = .numberPad
        case 3: textView.autocapitalizationType = .none
        default:
            break
        }
    }
}

// MARK: - Private function
private extension AddEventTableViewCell {
    
    func configuratonCell() {
        textView.delegate = self
    }
    
    func addSubview() {
        contentView.addSubview(dateView)
        contentView.addSubview(titleLabel)
        
    }
    
    func addConstraint() {
        dateView.frame = bounds
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    func convertDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let timeString = dateFormatter.string(from: date)
        return timeString
    }
}

// MARK: - UITextViewDelegate
extension AddEventTableViewCell: UITextViewDelegate {
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        
        switch textView.tag {
        case 2:
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: text)
            return allowedCharacters.isSuperset(of: characterSet)
        default:
            break
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        switch textView.tag {
        case 0:
            var key: String? {
                if !textView.text.isEmpty {
                    return textView.text
                } else {
                    return nil
                }
            }
            
            onKey?(key)
            
        case 1:
            var strValue: String? {
                if !textView.text.isEmpty {
                    return textView.text
                } else {
                    return nil
                }
            }
            
            onString?(strValue)
            
        case 2:
            var intValue: Int? {
                if !textView.text.isEmpty {
                    return Int(textView.text)
                } else {
                    return nil
                }
            }
            
            onInt?(intValue)
    
        case 3:
            var boolValue: Bool? {
                if !textView.text.isEmpty &&  textView.text == "true" {
                    return true
                } else if !textView.text.isEmpty &&  textView.text == "false" {
                    return false
                } else {
                    return nil
                }
            }
            
            onBool?(boolValue)
            
        default:
            break
        }
    }
}
