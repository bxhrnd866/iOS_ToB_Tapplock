//
//  APICode.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/13.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import Foundation

struct APICode {
    var code: Int
    
    var rawValue: String {
        
        switch code {
        case 100:
            return R.string.localizable.pmManageAllUsers()
        case 101:
            return R.string.localizable.pmManageAllLocks()
        case 102:
            return R.string.localizable.pmManageAllAccess()
        case 103:
            return R.string.localizable.pmManageAdmins()
        case 104:
            return R.string.localizable.pmViewAllGroupsInfo()
        case 105:
            return R.string.localizable.pmManageGroups()
        case 200:
            return R.string.localizable.pmManageUsers()
        case 201:
            return R.string.localizable.pmManageLock()
        case 202:
            return R.string.localizable.pmManageAccess()
        case 203:
            return R.string.localizable.pmManageMorsecod()
        case 204:
            return R.string.localizable.pmViewHistory()
        case 205:
            return R.string.localizable.pmManageOperationalPermission()
        case 300:
            return R.string.localizable.pmAssignedgroups()
        case 301:
            return R.string.localizable.pmAccesshistory()
        case 302:
            return R.string.localizable.pmReceivenotifications()
        case 303:
            return R.string.localizable.pmInitiatefirmwareupdates()
        case 400000:
            return R.string.localizable.code400000()
        case 400001:
            return R.string.localizable.code400001()
        case 400002:
            return R.string.localizable.code400002()
        case 400003:
            return R.string.localizable.code400003()
        case 400004:
            return R.string.localizable.code400004()
        case 400005:
            return R.string.localizable.code400005()
        case 400006:
            return R.string.localizable.code400006()
        case 400007:
            return R.string.localizable.code400007()
        case 400008:
            return R.string.localizable.code400008()
        case 400009:
            return R.string.localizable.code400009()
        case 400010:
            return R.string.localizable.code400010()
        case 400011:
            return R.string.localizable.code400011()
        case 400012:
            return R.string.localizable.code400012()
        case 400013:
            return R.string.localizable.code400013()
        case 400014:
            return R.string.localizable.code400014()
        case 400015:
            return R.string.localizable.code400015()
        case 400016:
            return R.string.localizable.code400016()
        case 400017:
            return R.string.localizable.code400017()
        case 400018:
            return R.string.localizable.code400018()
        case 400019:
            return R.string.localizable.code400019()
        case 400020:
            return R.string.localizable.code400020()
        case 400021:
            return R.string.localizable.code400021()
        case 400022:
            return R.string.localizable.code400022()
        case 400023:
            return R.string.localizable.code400023()
            
        default:
            return "Server error"
        }
        
    }
}



