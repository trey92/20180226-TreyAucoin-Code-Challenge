//
//  PassTimeData.swift
//  ISS Pass Times
//
//  Created by Trey Aucoin on 2/25/18.
//

public typealias PassTimes = [[String : Double]]

struct PassTimeResponse: Codable {
    var message: String
    var request: [String : Double]
    var response: PassTimes
}
