//
//  Date.swift
//  NamadaExporer
//
//  Created by pnam on 05/02/2024.
//

import Foundation

private let dateFormatter = DateFormatter()

extension Date {
    func timeAgoString() -> String {
        let now = Date()
        let timeDifference = Int(now.timeIntervalSince(self))
        
        if timeDifference < 60 {
            return "Just now"
        } else if timeDifference < 120 {
            return "1 minute ago"
        } else if timeDifference < 3600 {
            return "\(timeDifference / 60) minutes ago"
        } else if timeDifference < 7200 {
            return "1 hour ago"
        } else if timeDifference < 86400 {
            return "\(timeDifference / 3600) hours ago"
        } else if timeDifference < 172800 {
            return "1 day ago"
        } else if timeDifference < 2592000 { // 30 days
            return "\(timeDifference / 86400) days ago"
        } else {
            return stringDate
        }
    }
    
    var stringDate: String {
        dateFormatter.dateFormat = "HH:mm, dd/MM/YYYY"
        return dateFormatter.string(from: self)
    }
}

extension Date {
    static func -(lhs: Date, rhs: Date) -> Date {
        let timeInterval = lhs.timeIntervalSince(rhs)
        return Date(timeInterval: timeInterval, since: Date())
    }
    
    static func +(lhs: Date, rhs: Date) -> Date {
        let timeInterval = lhs.timeIntervalSinceReferenceDate + rhs.timeIntervalSinceReferenceDate
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
}
