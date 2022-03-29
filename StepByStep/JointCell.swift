//
//  JointCell.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 16.01.2022.
//

import UIKit

final class JointCell: UITableViewCell {

	// MARK: - Private properties

	private let jointNameLabel = UILabel()
	private let xLabel = UILabel()
	private let yLabel = UILabel()

	private lazy var stackLabel: UIStackView = {
		let stack = UIStackView(arrangedSubviews: [jointNameLabel,
												   xLabel,
												   yLabel])
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.axis = .vertical
		return stack
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		jointNameLabel.text = "-"
		xLabel.text = "0"
		yLabel.text = "0"
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	init(jointName: String, x: CGFloat, y: CGFloat) {
		super.init(style: .default, reuseIdentifier: nil)
		setupCell(jointName: jointName, x: x, y: y)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Public methods

extension JointCell {

	func setupCell(jointName: String, x: CGFloat, y: CGFloat) {
		jointNameLabel.text = jointName
		xLabel.text = "x: \(x)"
		yLabel.text = "y: \(y)"
	}
}

// MARK: - Private methods

private extension JointCell {

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
