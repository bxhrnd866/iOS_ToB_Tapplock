//
//  HistoryTableHeaderView.swift
//  Tapplock2
//
//  Created by TapplockiOS on 2018/5/30.
//  Copyright © 2018年 Tapplock. All rights reserved.
//

import UIKit

class HistoryTableHeaderView: UITableViewHeaderFooterView {
  
    var labTime: UILabel?
    var labItems: UILabel?
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        let h = 26
        labTime = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: h))
        labTime?.textColor = UIColor("#686868")
        labTime?.font = UIFont(name: font_name, size: 12)
        self.contentView.addSubview(labTime!)
        
        labItems = UILabel(frame: CGRect(x: Int(mScreenW - 80), y: 0, width: 60, height: h))
        labItems?.textColor = UIColor("#686868")
        labItems?.font = UIFont(name: font_name, size: 12)
        labItems?.textAlignment = .right
        self.contentView.addSubview(labItems!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
