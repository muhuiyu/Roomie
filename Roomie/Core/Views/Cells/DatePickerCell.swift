//
//  DatePickerCell.swift
//  Anki CopyCat
//
//  Created by Mu Yu on 17/1/21.
//

import UIKit

protocol DatePickerCellDelegate: AnyObject {
    func selectedValueChanged(_ cell: DatePickerCell, changeValueTo value: Date)
}

class DatePickerCell: UITableViewCell {
    static let reuseID = "DatePickerCell"
    
    var value: Date? {
        get { return datePickerView.date }
        set { datePickerView.date = newValue ?? Date() }
    }
    var datePickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePickerView.datePickerMode = datePickerMode
        }
    }
    var preferredDatePickerStyle: UIDatePickerStyle = .inline {
        didSet {
            datePickerView.preferredDatePickerStyle = preferredDatePickerStyle
        }
    }
    
    private let datePickerView = UIDatePicker()
    weak var delegate: DatePickerCellDelegate?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
        configureConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Actions
extension DatePickerCell {
    @objc
    private func valueChanged() {
        delegate?.selectedValueChanged(self, changeValueTo: datePickerView.date)
    }
}
// MARK: - View Config
extension DatePickerCell {
    private func configureViews() {
        datePickerView.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        contentView.addSubview(datePickerView)
    }
    private func configureConstraints() {
        datePickerView.snp.remakeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
