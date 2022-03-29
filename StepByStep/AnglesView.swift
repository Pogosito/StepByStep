//
//  AnglesView.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 19.01.2022.
//

import UIKit

/// Вью для отображения информации об углах скелета человека в определенном порядке
final class AnglesView: UIView {

	// MARK: - Private properties

	private var angles: [JointAngle: CGFloat] = [:]

	private let tableViewCellId = "AngleCell"

	private let allAngles: [JointAngle] = [.leftKnee,
										   .leftLegAndBody,
										   .rightKnee,
										   .rightLegAndBody,
										   .leftHip,
										   .rightHip,
										   .bodyLeftShoulder,
										   .bodyLeftTorso,
										   .bodyRightShoulder,
										   .bodyRightTorso]

	private let numberOfSection = 2

	private let headerView: UILabel = {
		let headerView = UILabel()
		headerView.backgroundColor = .systemOrange
		headerView.frame.size.height = 50
		headerView.textAlignment = .center
		return headerView
	}()

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(AnglesCell.self, forCellReuseIdentifier: tableViewCellId)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.tableHeaderView = headerView
		return tableView
	}()

	init(angles: [JointAngle: CGFloat] = [:], header: String) {
		self.angles = angles
		headerView.text = header
		super.init(frame: .zero)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Public methods

extension AnglesView {

	func update(angles: [JointAngle: CGFloat]) {
		self.angles = angles
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate

extension AnglesView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - UITableViewDataSource

extension AnglesView: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { allAngles.count }

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? AnglesCell else { return UITableViewCell() }
		let currentAngle = allAngles[indexPath.row]
		let angleValue = angles[currentAngle]

		cell.setUpCell(angleName: currentAngle.nameOfAngle, angleValue: angleValue ?? 0)
		return cell
	}
}

// MARK: - Private methods

private extension AnglesView {

	func setupUI() {
		addSubview(tableView)

		NSLayoutConstraint.activate([
			tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
			tableView.topAnchor.constraint(equalTo: topAnchor),
			tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
}
