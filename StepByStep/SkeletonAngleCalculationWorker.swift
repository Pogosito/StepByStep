//
//  SkeletonAngleCalculationWorker.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 19.01.2022.
//

import UIKit

/// Протокол воркера для подсчета углов для суставов скелета
protocol SkeletonAngleCalculationWorkerProtocol {

	/// Вычислить углы суставов скелета
	/// - Parameters:
	///   - jointAngles: Углы, которые нужно найти
	///   - joints: Список с суставами скелета и их расположеним
	///   - transform: Аффинное преобразование координат суставов скелета
	/// - Returns: Список углов и их значения угла в градусах
	func calculate(jointAngles: [JointAngle], joints: [JointName : CGPoint], applying transform: CGAffineTransform) -> [JointAngle: CGFloat]
}

final class SkeletonAngleCalculationWorker {}

// MARK: - SkeletonAngleCalculationWorkerProtocol

extension SkeletonAngleCalculationWorker: SkeletonAngleCalculationWorkerProtocol {

	func calculate(jointAngles: [JointAngle], joints: [JointName : CGPoint], applying transform: CGAffineTransform) -> [JointAngle: CGFloat] {
		var result: [JointAngle: CGFloat] = [:]

		for jointAngle in jointAngles {
			let jointsOfAngle = jointAngle.rawValue
			guard let firstJointLocation = joints[jointsOfAngle.0],
				  let secondJointLocation = joints[jointsOfAngle.1],
				  let thirdJointLocation = joints[jointsOfAngle.2] else {
				print("Can't calculate angle for \(jointAngle)")
				continue
			}

			let vector1 = firstJointLocation.applying(transform) - secondJointLocation.applying(transform)
			let vector2 = thirdJointLocation.applying(transform) - secondJointLocation.applying(transform)

			let angle = vector1.angle(between: vector2)
			result[jointAngle] = angle
		}
		return result
	}
}
