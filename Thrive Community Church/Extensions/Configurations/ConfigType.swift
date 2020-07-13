//
//  ConfigType.swift
//  Thrive Church Official App
//
//  Created by Wyatt Baggett on 6/27/20.
//  Copyright © 2020 Thrive Community Church. All rights reserved.
//

import UIKit

enum ConfigType: String, Codable {
	case Phone
	case Email
	case Link
	case Misc
	case Social
	
	enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .Phone
        case 1:
            self = .Email
        case 2:
            self = .Link
        case 3:
            self = .Misc
        case 4:
            self = .Social
        default:
            throw CodingError.unknownValue
        }
    }
	
	init(from: String) throws {
        switch from {
        case "Phone":
            self = .Phone
        case "Email":
            self = .Email
        case "Link":
            self = .Link
        case "Misc":
            self = .Misc
		case "Social":
			self = .Social
		default:
			throw CodingError.unknownValue
		}
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .Phone:
            try container.encode(0, forKey: .rawValue)
        case .Email:
            try container.encode(1, forKey: .rawValue)
        case .Link:
            try container.encode(2, forKey: .rawValue)
        case .Misc:
            try container.encode(3, forKey: .rawValue)
        case .Social:
            try container.encode(4, forKey: .rawValue)
        }
    }
}
