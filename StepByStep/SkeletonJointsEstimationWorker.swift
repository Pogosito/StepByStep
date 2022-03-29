//
//  SkeletonJointsEstimationWorker.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 23.11.2021.
//

import Vision
import UIKit

/// Протокол воркера, который определят по изображению координаты точек скелета человека
protocol SkeletonJointsEstimationWorkerProtocol: AnyObject {

	/// Определяет координаты точек скелета человека на изображении
	/// - Parameters:
	///   - ciImage: Изображение в виде объекта `CIImage`
	///   - orientation: Ориентация изображения
	///   - options: Список дополнительных настроек для изображений
	///   - completion: Блок завершения, в котором происходит обработка полученных точек
	func retrieveSkeletonPoints(from ciImage: CIImage,
								orientation: CGImagePropertyOrientation,
								options: [VNImageOption: Any],
								completion: @escaping (Result<[JointName: CGPoint], Error>) -> Void)
}

/// Воркер для определения координат точек скелета человека
final class SkeletonJointsEstimationWorker {}

// MARK: - SkeletonEstimationWorkerProtocol

extension SkeletonJointsEstimationWorker: SkeletonJointsEstimationWorkerProtocol {

	func retrieveSkeletonPoints(from ciImage: CIImage,
								orientation: CGImagePropertyOrientation,
								options: [VNImageOption: Any],
								completion: @escaping (Result<[JointName: CGPoint], Error>) -> Void) {
		let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation, options: options)
		make(requestHandler: requestHandler, completion: completion)
	}
}

// MARK: - Helper methods

private extension SkeletonJointsEstimationWorker {

	func make(requestHandler: VNImageRequestHandler,
			  completion: @escaping (Result<[JointName: CGPoint], Error>) -> Void) {
		let humanBodyPoseRequest = VNDetectHumanBodyPoseRequest { request, error in

			guard error == nil else { fatalError() }

			guard let observation = request.results?.first as? VNHumanBodyPoseObservation else { return }

			guard let recognizedPoints = try? observation.recognizedPoints(.all) else { return }
			
			var resultDictionary: [JointName: CGPoint] = [:]

			for jointName in Constants.Joints.all {
				guard let safePoint = recognizedPoints[jointName], safePoint.confidence > 0 else { continue }
				resultDictionary[jointName] = safePoint.location
			}

			completion(.success(resultDictionary))
		}

		do {
			try requestHandler.perform([humanBodyPoseRequest])
		} catch let error as NSError {
			print(error)
		}
	}
}
