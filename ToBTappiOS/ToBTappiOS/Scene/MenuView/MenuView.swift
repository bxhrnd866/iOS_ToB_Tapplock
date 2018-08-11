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
    let viewModel = MenuViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
  
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.72)
        
        let bgview = UIView(frame: CGRect(x: 0, y: 0, width: 242 * mScale, height: mScreenH - TopBarHeight))
        bgview.backgroundColor = UIColor.white
        addSubview(bgview)
        
      
        let rightBtn = UIButton(type: .custom)
        rightBtn.frame = CGRect(x: bgview.rightX, y: 0, width: mScreenW - 242 * mScale, height: mScreenH - TopBarHeight)
        rightBtn.rx.tap.subscribe(onNext: { [weak self] in
            self?.hiddenMenuView()
        }).disposed(by: rx.disposeBag)
        
        addSubview(rightBtn)
        
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
    
    public func showLeftMenuView() {
        let wind = UIApplication.shared.delegate?.window!
        wind?.bringSubview(toFront: self)
        UIView.animate(withDuration: timeInterval) {
            self.transform = CGAffineTransform.init(translationX: mScreenW, y: 0)
        }
    }
    
    public func hiddenMenuView() {
        UIView.animate(withDuration: timeInterval) {
            self.transform = CGAffineTransform.identity
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        plog("menu销毁了")
    }
    
}

extension MenuView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rx_list.value.count
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewCellIdentifier", for: indexPath) as! MenuTableViewCell
        cell.model = viewModel.rx_list.value[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == viewModel.rx_list.value.count - 1 {
            self.rx_logout.value = true
            self.hiddenMenuView()
            return
        }

       
        if rx_SelectIndex.value != indexPath.row {
            
            let model = viewModel.rx_list.value[rx_SelectIndex.value]
            model.select = false
            let m2 = viewModel.rx_list.value[indexPath.row]
            m2.select = true
            rx_SelectIndex.value = indexPath.row
            self.tableView.reloadData()
            
            self.hiddenMenuView()
        }

    }
    
   
}
