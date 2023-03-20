//
//  WeightAndRepetitionProtocol.swift
//  ColorDumbbell
//
//  Created by myungsun on 2023/03/17.
//

import Foundation

protocol WeightAndRepetitionDelegate: AnyObject {
    func transferData(section: Int, row: Int, weight: Double, reps: Int)
}
