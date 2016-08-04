//
//  IssuePosition.swift
//  
//
//  Created by Adam Barr-Neuwirth on 8/3/16.
//
//
import Foundation

@objc public class IssuePosition: NSObject {

    var type: IssuePositionType = .Neutral
    var text: NSString?
    
    @objc enum IssuePositionType: NSInteger {
        case For
        case Against
        case Neutral
    }
    
    class func issuePositionWithType(type: IssuePositionType) -> IssuePosition {
        return self.issuePositionWithType(type, text: nil)
    }

    class func issuePositionWithType(type: IssuePositionType, text: NSString?) -> IssuePosition {
        let issue: IssuePosition = IssuePosition()
        issue.type = type
        issue.text = text!
        return issue
    }

    class func typeFromNumber(number: NSNumber) -> IssuePositionType {
        switch CInt(number.intValue) {
            case 1:
                return .For
            case 0:
                return .Against
            default:
                return .Neutral
        }
        
    }
}