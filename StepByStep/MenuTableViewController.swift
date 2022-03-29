//
//  MenuTableViewController.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 28.11.2021.
//

import UIKit

final class MenuTableViewController: UITableViewController {

	private let cellId = "Cell"
	private let cellTitles = ["Comparison of poses on video"]

	private let coreDataStack = CoreDataStack(modelName: "StepByStep")
	private lazy var jointsStorageWorker = JointsStorageWorker(coreDataStack: coreDataStack)

	private let skeletonEstimationWorker = SkeletonJointsEstimationWorker()
	private let skeletonPainterWorker = SkeletonPainterWorker()
	private let skeletonAngleCalculationWorker = SkeletonAngleCalculationWorker()
	private let videoProcessWorker = VideoProcessWorker()
	private let rightSquatVideoPath = URL(fileURLWithPath: Bundle.main.path(forResource: Videos.RightSquat.rawValue,
																			ofType: VideoTypes.mp4.rawValue) ?? "")

	private let wrongSquatVideoPath = URL(fileURLWithPath: Bundle.main.path(forResource: Videos.NotFullySquat.rawValue,
																			ofType: VideoTypes.mp4.rawValue) ?? "")

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
	}
}

// MARK: - Table view methods

extension MenuTableViewController {

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
		cell.textLabel?.text = cellTitles[indexPath.row]
		return cell
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		var viewController: UIViewController
		switch indexPath.row {
		case 0: viewController = ComparatorsOfTwoSequencesViewController(skeletonEstimationWorker: skeletonEstimationWorker,
																		 skeletonPainterWorker: skeletonPainterWorker,
																		 skeletonAngleCalculationWorker: skeletonAngleCalculationWorker,
																		 jointsStorage: jointsStorageWorker,
																		 videoProcessWorker: videoProcessWorker,
																		 rightRepetitionVideoPath: rightSquatVideoPath,
																		 wrongRepetitionVideoPath: wrongSquatVideoPath)
		default: fatalError()
		}

		navigationController?.pushViewController(viewController, animated: true)
	}
}
