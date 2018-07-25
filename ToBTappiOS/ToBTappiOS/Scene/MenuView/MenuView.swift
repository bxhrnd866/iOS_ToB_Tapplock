//
//  MenuView.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/7/3.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher
class MenuView: UIView {
    
    let timeInterval = 0.35
    
    
    var rx_SelectIndex: Variable<Int> = Variable(1)
    var rx_logout: Variable<Bool> = Variable(false)
    
    
    private var headerImg: UIImageView!
    private var namelab: UILabel!
    private var tableView: UITableView!
    private let viewModel = MenuViewModel()
    
    static let instance: MenuView = MenuView(frame: CGRect(x: -mScreenW, y: TopBarHeight, width: mScreenW, height: mScreenH - TopBarHeight))
    override init(frame: CGRect) {
        super.init(frame: frame)
  
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.72)
        
        let bgview = UIView(frame: CGRect(x: 0, y: 0, width: 242 * mScale, height: mScreenH - TopBarHeight))
        bgview.backgroundColor = UIColor.white
        addSubview(bgview)
        
        let rightBg = UIView(frame: CGRect(x: bgview.rightX, y: 0, width: mScreenW - 242 * mScale, height: mScreenH - TopBarHeight))
        rightBg.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToRecovery))
        rightBg.addGestureRecognizer(tap)
        addSubview(rightBg)
        
        self.headerImg = UIImageView(frame: CGRect(x: 76 * mScale, y: 37 * mScale, width: 90 * mScale, height: 90 * mScale))
        self.headerImg.layer.cornerRadius = 4
        self.headerImg.layer.masksToBounds = true
        self.headerImg.image = R.image.userPlace()
        bgview.addSubview(self.headerImg)
        
        namelab = UILabel(frame: CGRect(x: 0, y: self.headerImg.bottomY + 15 * mScale, width: bgview.width, height: 33))
        namelab.textAlignment = .center
        namelab.font = UIFont(name: font_name, size: 24 * mScale)
        namelab.text = "Tapplock"
        bgview.addSubview(self.namelab)
        
        let line = UIView(frame: CGRect(x: 0, y: 27 * mScale + namelab.bottomY, width: bgview.width, height: 1))
        line.backgroundColor = UIColor("#f1f1f1")
        bgview.addSubview(line)

        tableView = UITableView(frame: CGRect(x: 0, y: line.bottomY, width: bgview.width, height: bgview.height - line.bottomY))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "tableviewCellIdentifier")
        bgview.addSubview(tableView)
        
     
        ConfigModel.default.user.asDriver().filter {
            $0 != nil
            }.drive(onNext: { [weak self] user in
                self?.namelab.text = "\(user?.firstName ?? "")" + "\(user?.lastName ?? "")"
                
                if user?.photoUrl != nil, let url = URL(string: (user?.photoUrl)!) {
                    self?.headerImg.kf.setImage(with: ImageResource.init(downloadURL: url), options: [.processor(kfProcessor)])
                }
                
                
            }).disposed(by: rx.disposeBag)
       
    }
    @objc private func tapToRecovery() {
        UIView.animate(withDuration: timeInterval) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    public func commeTransform() {
        let wind = UIApplication.shared.delegate?.window!
        wind?.bringSubview(toFront: self)
        UIView.animate(withDuration: timeInterval) {
            self.transform = CGAffineTransform.init(translationX: mScreenW, y: 0)
        }
    }
    
    public func recovery() {
        UIView.animate(withDuration: timeInterval) {
            self.transform = CGAffineTransform.identity
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ConfigModel.default.user.value != nil ? (ConfigModel.default.user.value?.meunSoure.count)! : 0
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewCellIdentifier", for: indexPath) as! MenuTableViewCell
        cell.lable.text = viewModel.dataSource[indexPath.row]
        
//        cell.lable.text = ConfigModel.default.user.value?.meunSoure[indexPath.row]
        
        if indexPath.row == 1 {
            cell.backgroundColor = thembColor
            cell.lable.textColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuTableViewCell
        
        if indexPath.row == 6 {
            rx_logout.value = true
            self.recovery()
            return
        }
        
        if rx_SelectIndex.value != indexPath.row {
            let before = tableView.cellForRow(at: IndexPath(row: rx_SelectIndex.value, section: 0)) as! MenuTableViewCell
            before.backgroundColor = UIColor.white
            before.lable.textColor = UIColor.black
            cell.backgroundColor = thembColor
            cell.lable.textColor = UIColor.white
            rx_SelectIndex.value = indexPath.row
            self.recovery()
        }
    }
}
