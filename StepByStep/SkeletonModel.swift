//
//  SkeletonModel.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 13.11.2021.
//

import Vision
import UIKit

/// Протокол модели скелета человека.
protocol SkeletonModelProtocol: AnyObject {

	/// Изображение, на котором происходит поиск человеческого скелета.
	var image: UIImage { get }

	/// Нормализованные координаты суставов скелета.
	var normalizedSkeletonPoints: [JointName: CGPoint] { get }

	/// Поиск суставов скелета на изображении с использованием `CIImage`.
	/// - Parameter completion: Замыкание для дальнейшего использования, полученных точек.
	func findSkeletonJointsInCIImageAndProcess(
		in completion: @escaping ([JointName: CGPoint]) -> Void
	)

	/// Получить относительные координаты суставов.
	/// - Parameter joint: Сустав, относительно которого будет происходит перерасчет.
	func getSkeletonJointsPositionRelative(
		to joint: JointName
	) -> [JointName: CGPoint]?
}

/// Модель скелета человека на изображении.
final class SkeletonModel {

	// MARK: - SkeletonEstimationModelProtocol properties

	var image = UIImage()

	var normalizedSkeletonPoints: [JointName: CGPoint] = [:]

	// MARK: - Private properties

	private let skeletonEstimationWorker: SkeletonJointsEstimationWorkerProtocol

	/// Инициализатор.
	/// - Parameters:
	///   - skeletonEstimationWorker: Воркер для поиска скелета чекловека на изображении.
	///   - image: Изображение, на котором происходит поиск человеческого скелета.
	init(skeletonEstimationWorker: SkeletonJointsEstimationWorkerProtocol,
		 image: UIImage) {
		self.skeletonEstimationWorker = skeletonEstimationWorker
		self.image = image
	}

	/// Инициализатор.
	/// - Parameter skeletonEstimationWorker: Воркер для поиска скелета чекловека на изображении.
	init(skeletonEstimationWorker: SkeletonJointsEstimationWorkerProtocol) {
		self.skeletonEstimationWorker = skeletonEstimationWorker
	}
}

// MARK: - SkeletonEstimationModelProtocol methods

extension SkeletonModel: SkeletonModelProtocol {

	func findSkeletonJointsInCIImageAndProcess(
		in completion: @escaping ([JointName: CGPoint]) -> Void
	) {

		guard let safeCIImage = image.ciImage else {
			print("Didn't find ciImage in your image")
			return
		}

		skeletonEstimationWorker.retrieveSkeletonPoints(from: safeCIImage,
														orientation: .up,
														options: [:]) { result in
			self.process(result: result, with: completion)
		}
	}

	func getSkeletonJointsPositionRelative(
		to joint: JointName
	) -> [JointName: CGPoint]? {

		var relativePointsOfJoints: [JointName: CGPoint] = [:]

		guard let rootPosition = normalizedSkeletonPoints[joint] else {
			print("Joint \(joint.rawValue.rawValue) can't be root")
			return nil
		}

		for joint in Constants.Joints.all {
			guard let absoluteJointPosition = normalizedSkeletonPoints[joint] else { continue }

			let x = rootPosition.x - absoluteJointPosition.x
			let y = rootPosition.y - absoluteJointPosition.y

			let relativePoint = CGPoint(x: x, y: y == 0 ? y : -y)

			relativePointsOfJoints[joint] = relativePoint
		}

		return relativePointsOfJoints
	}
}

// MARK: - Helper methods

private extension SkeletonModel {

	func process(result: Result<[JointName : CGPoint], Error>,
				 with completion: @escaping ([JointName: CGPoint]) -> Void) {
		switch result {
		case let .success(points):
			self.normalizedSkeletonPoints = points
			completion(points)
		case let .failure(error):
			print("Error can't find key points \(error)")
		}
	}
}
