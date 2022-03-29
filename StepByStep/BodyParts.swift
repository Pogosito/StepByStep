//
//  BodyParts.swift
//  StepByStep
//
//  Created by Pogos Anesyan on 26.01.2022.
//

import Vision

enum BodyParts {

	case body
	case leftArm
	case rightArm
	case leftLeg
	case rightLeg

	var joints: [JointName] {
		switch self {
		case .body: return Constants.Joints.body
		case .leftArm: return Constants.Joints.leftArm
		case .rightArm: return Constants.Joints.rightArm
		case .leftLeg: return Constants.Joints.leftLeg
		case .rightLeg: return Constants.Joints.rightLeg
		}
	}
}

struct BodyPart {
	var joints: [JointName]
	var angles: JointAngle
}
