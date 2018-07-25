//
//  APICode.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/13.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

enum APICode {
    case nonononoonno
    // 权限
    case PermissionManageGroup
    case PermissionManageAdmins
    case PermissionFinace
    case PermissionManageUser
    case PermissionManageLock
    case PermissionManageMorseCode
    case PermissionManageAccess
    case PermissionAuditReport
    case PermissionViewAllLocks
    case PermissionViewAllAccessHistory
    case PermissionInitateFirmwareUpdate
    
    
    
    init(_ code: Int) {
        switch code {
        case 100:
            self = .PermissionManageGroup
        case 101:
            self = .PermissionManageAdmins
        case 102:
            self = .PermissionFinace
        case 200:
            self = .PermissionManageUser
        case 201:
            self = .PermissionManageLock
        case 202:
            self = .PermissionManageMorseCode
        case 203:
            self = .PermissionManageAccess
        case 204:
            self = .PermissionAuditReport
        case 300:
            self = .PermissionViewAllLocks
        case 301:
            self = .PermissionViewAllAccessHistory
        case 302:
            self = .PermissionInitateFirmwareUpdate
            
        default:
            self = .nonononoonno
        }
    }
    
    var rawValue: String! {
        switch self {
        case .PermissionManageGroup:
            return R.string.localizable.permissionManageGroup()
        case .PermissionManageAdmins:
            return R.string.localizable.permissionManageAdmins()
        case .PermissionFinace:
            return R.string.localizable.permissionFinace()
        case .PermissionManageUser:
            return R.string.localizable.permissionManageUser()
        case .PermissionManageLock:
            return R.string.localizable.permissionManageLock()
        case .PermissionManageMorseCode:
            return R.string.localizable.permissionManageMorseCode()
        case .PermissionManageAccess:
            return R.string.localizable.permissionManageAccess()
        case .PermissionAuditReport:
            return R.string.localizable.permissionAuditReport()
        case .PermissionViewAllLocks:
            return R.string.localizable.permissionViewAllLocks()
        case .PermissionViewAllAccessHistory:
            return R.string.localizable.permissionViewAllAccessHistory()
        case .PermissionInitateFirmwareUpdate:
            return R.string.localizable.permissionInitateFirmwareUpdate()
        default:
            return "nonononono"
        }
    }

}
