//
//  AnglesCell.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 22.01.2022.
//

import UIKit

final class AnglesCell: UITableViewCell {

	// MARK: - Private properties

	private let angleNameLabel = UILabel()
	private let angleValueLabel = UILabel()

	private lazy var stackLabel: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [angleNameLabel,
												   angleValueLabel])
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		return stack
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		angleNameLabel.text = "-"
		angleValueLabel.text = "0 °"
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	init(angleName: String, angleValue: Float) {
		super.init(style: .default, reuseIdentifier: nil)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Public methods

extension AnglesCell {

	func setUpCell(angleName: String, angleValue: CGFloat) {
		angleNameLabel.text = angleName
		angleValueLabel.text = "\(angleValue) °"
	}
}

// MARK: - Private methods

private extension AnglesCell {

	func setupUI() {
		addSubview(stackLabel)
		NSLayoutConstraint.activate([
			stackLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			stackLabel.topAnchor.constraint(equalTo: topAnchor),
			stackLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
