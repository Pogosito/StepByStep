//
//  JointsView.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 15.01.2022.
//

import UIKit
import Vision

final class JointsView: UIView {

	// MARK: - Private properties

	private let allJoint = Constants.Joints.all
	private var joints: [JointName: CGPoint] = [:]

	private let tableViewCellId = "JointCell"
	private lazy var allRightJoints = allJoint.filter { $0.rawValue.rawValue.contains("right") }
	private lazy var allLeftJoints = allJoint.filter { $0.rawValue.rawValue.contains("left") }

	private let numberOfSection = 3

	private let headerView: UILabel = {
		let headerView = UILabel()
		headerView.textAlignment = .center
		headerView.backgroundColor = .systemIndigo
		headerView.frame.size.height = 50
		return headerView
	}()

	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(JointCell.self, forCellReuseIdentifier: "JointCell")
		tableView.delegate = self
		tableView.tableHeaderView = headerView
		tableView.dataSource = self
		return tableView
	}()

	init(joints: [JointName: CGPoint] = [:], header: String) {
		self.joints = joints
		headerView.text = header
		super.init(frame: .zero)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Public methods

extension JointsView {

	func update(joints: [JointName: CGPoint]) {
		self.joints = joints
		tableView.reloadData()
	}
}

// MARK: - UITableViewDelegate

extension JointsView: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}

// MARK: - UITableViewDataSource

extension JointsView: UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int { numberOfSection }

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		let allJointsCount = allJoint.count
		let rightJointsCount = allRightJoints.count
		let leftJointsCount = allLeftJoints.count

		switch section {
		case 0: return allJointsCount - rightJointsCount - leftJointsCount
		case 1: return rightJointsCount
		case 2: return leftJointsCount
		default: return 0
		}
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var jointName: String = ""
		guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId, for: indexPath) as? JointCell else {
			print("Can't cast cell to appropriate type")
			return UITableViewCell()
		}

		switch indexPath.section {
		case 1: jointName = allRightJoints[indexPath.item].rawValue.rawValue
		case 2: jointName = allLeftJoints[indexPath.item].rawValue.rawValue
		default: jointName = allJoint[indexPath.item].rawValue.rawValue
		}

		let point = joints[JointName.init(rawValue: VNRecognizedPointKey(rawValue: jointName))]

		cell.setupCell(jointName: jointName,
					   x: point?.x ?? 0,
					   y: point?.y ?? 0)
		return cell
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0: return "Main part"
		case 1: return "Right part"
		default: return "Left part"
		}
	}
}

// MARK: - Private methods

private extension JointsView {

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
