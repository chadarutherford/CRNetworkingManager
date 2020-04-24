//
//  File.swift
//  
//
//  Created by Chad Rutherford on 4/24/20.
//

import Foundation

public enum NetworkError: Error {
	case unknownError
	case invalidResponse
	case invalidData
	case decodeError
}
