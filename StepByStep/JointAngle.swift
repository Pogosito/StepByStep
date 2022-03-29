//
//  JointAngle.swift
//  StepByStep
//
//  Created by Pogos Anesyn on 22.01.2022.
//

import Vision

/// Углы скелета человека
enum JointAngle: RawRepresentable {

	/// Правое колено
	case rightKnee

	/// Левое колено
	case leftKnee

	/// Угол между правой ногой и телом
	case rightLegAndBody

	/// Угол между левой ногой и телом
	case leftLegAndBody

	/// Правое бедро
	case rightHip

	/// Левое бедро
	case leftHip

	// MARK: Внутренние углы тела

	/// Тело правый торс
	case bodyRightTorso

	/// Тело левый торс
	case bodyLeftTorso

	/// Тело левое плечо
	case bodyLeftShoulder

	/// Тело правое плечо
	case bodyRightShoulder

	var rawValue: (JointName, JointName, JointName) {
		switch self {
		case .rightKnee: return (.rightAnkle, .rightKnee, .rightHip)
		case .leftKnee: return (.leftAnkle, .leftKnee, .leftHip)
		case .rightLegAndBody: return (.rightKnee, .rightHip, .leftHip)
		case .leftLegAndBody: return (.leftKnee, .leftHip, .rightHip)
		case .rightHip: return (.rightShoulder, .rightHip, .rightKnee)
		case .leftHip: return (.leftShoulder, .leftHip, .leftKnee)
		case .bodyRightTorso: return (.rightShoulder, .rightHip, .leftHip)
		case .bodyLeftTorso: return (.rightHip, .leftHip, .leftShoulder)
		case .bodyLeftShoulder: return (.leftHip, .leftShoulder, .rightShoulder)
		case .bodyRightShoulder: return (.leftShoulder, .rightShoulder, .rightHip)
		}
	}

	var nameOfAngle: String {
		switch self {
		case .rightKnee: return "Правое колено"
		case .leftKnee: return "Левое колено"
		case .rightLegAndBody: return "Правая нога и тело"
		case .leftLegAndBody: return "Левая нога и тело"
		case .rightHip: return "Правое бедро"
		case .leftHip: return "Левое бедро"
		case .bodyRightTorso: return "Тело, правый торс"
		case .bodyLeftTorso: return "Тело, левый торс"
		case .bodyLeftShoulder: return "Тело, левое плечо"
		case .bodyRightShoulder: return "Тело, правое плечо"
		}
	}

	init?(rawValue: (JointName, JointName, JointName)) {
		switch rawValue {
		case (.rightAnkle, .rightKnee, .rightHip): self = .rightKnee
		case (.leftAnkle, .leftKnee, .leftHip): self = .leftKnee
		case (.rightKnee, .rightHip, .leftHip): self = .rightLegAndBody
		case (.leftKnee, .leftHip, .rightHip): self = .leftLegAndBody
		case (.leftShoulder, .leftHip, .leftKnee): self = .leftHip
		case (.rightShoulder, .rightHip, .rightKnee): self = .rightHip
		case (.rightShoulder, .rightHip, .leftHip): self = .bodyRightTorso
		case (.rightHip, .leftHip, .leftShoulder): self = .bodyLeftTorso
		case (.leftShoulder, .rightShoulder, .rightHip): self = .bodyRightShoulder
		default: return nil
		}
	}
}
