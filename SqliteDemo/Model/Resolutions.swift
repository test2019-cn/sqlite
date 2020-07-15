//
//  Resolutions.swift
//  LocQAAnalyzer
//
//  Created by Tiny Liu on 2020/4/28.
//  Copyright © 2020 wistron. All rights reserved.
//

public enum Resolution: String, CaseIterable, Codable, CustomStringConvertible {

    case unresolved = "Unresolved"
    case softwareChanged = "Software Changed"
    case documentationChanged = "Documentation Changed"
    case dataChanged = "Data Changed"
    case hardwareChanged = "Hardware Changed"
    case configurationChanged = "Configuration Changed"
    case featureRemoved = "Feature Removed"
    case duplicate = "Duplicate"
    case cannotReproduce = "Cannot Reproduce"
    case behavesCorrectly = "Behaves Correctly"
    case notToBeFixed = "Not To Be Fixed"
    case thrPartyToResolve = "3rd Party To Resolve"
    case firmwareChanged = "Firmware Changed"
    case vendorDisqualified = "Vendor Disqualified"
    case processChanged = "Process Changed"
    case insufficientInformation = "Insufficient Information"
    case itemCompleted = "Item Completed"
    case notApplicable = "Not Applicable"

    public var description: String {
        return self.rawValue
    }
}
