//
//  Extensions+GlobalFunction.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 16.11.2021.
//

import UIKit


// MARK: - Global functions

func sum(of joints: [JointName: CGPoint]) -> CGPoint {
	var result: CGPoint = .zero
	for joint in joints {
		result = result + joint.value
	}
	return result
}

// MARK: - CIImage

extension CIImage {

	/// Конвертирует `CIImage` в `CGImage`
	func convertToCGImage() -> CGImage? {
		let context = CIContext(options: nil)
		guard let safeCGImage = context.createCGImage(self, from: self.extent) else { return nil }
		return safeCGImage
	}
}

// MARK: - CGPoint

extension CGPoint {

	static func -(lhs: CGPoint, rhs: CGPoint) -> CGVector {
		CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
	}

	static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
		CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
}

// MARK: - CGVector

extension CGVector {

	/// Норма вектора
	var norm: CGFloat { sqrt(self.dx * self.dx + self.dy * self.dy) }

	/// Поиск угла между вектором
	/// - Parameter vector: Вектор, между которым ищем угол
	/// - Returns: Угол (в градусах) между переданным вектором
	func angle(between vector: CGVector) -> CGFloat {
		let cosBetweenVectors = scalarMultiply(by: vector) / (self.norm * vector.norm)
		let arccos = acos(cosBetweenVectors)
		let degrees = arccos * 180 / .pi
		return degrees
	}
	
	/// Скалярное произведение векторов
	func scalarMultiply(by vector: CGVector) -> CGFloat { self.dx * vector.dx + self.dy * vector.dy }
}
