//
//  ServiceContainerProtocol.swift
//  NappyChangeTracker
//
//  Created by David Thorn on 13.02.2026.
//

import Foundation

internal protocol ServiceContainerProtocol {
    var nappyChangeService: NappyChangeServiceProtocol { get }
}
