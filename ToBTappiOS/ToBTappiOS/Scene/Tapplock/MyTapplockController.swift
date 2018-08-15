//
//  MyTapplockController.swift
//  ToBTappiOS
//
//  Created by nb616 on 2018/6/14.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import Instructions
class MyTapplockController: BaseViewController {
    
    @IBOutlet weak var bleBtn: UIButton!
    
    @IBOutlet weak var fingerBtn: UIButton!
    
    @IBOutlet weak var underLine: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var groupLab: UILabel!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var searchBtn: UIBarButtonItem!
    
    let coachMarksController = CoachMarksController()
    
    let viewModel = TapplockViewModel()
    
    
    var isBLE: Bool! {
        if self.underLine.transform.tx == mScreenW / 2 {
            return false
        } else {
            return true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TapplockManager.default.rx_viewmodel = viewModel
        
        
        bleBtn.rx.tap.subscribe(onNext: { [weak self] in
            
            if self?.viewModel.rx_authType.value == 0 {
                return
            }
            self?.bleBtn.setTitleColor(UIColor.black, for: .normal)
            self?.fingerBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.identity
            
            self?.viewModel.rx_authType.value = 0
            self?.tableView.mj_header.beginRefreshing()
            
            
        }).disposed(by: rx.disposeBag)
        
        fingerBtn.rx.tap.subscribe(onNext: { [weak self] in

            if self?.viewModel.rx_authType.value == 1 {
                return
            }
            self?.fingerBtn.setTitleColor(UIColor.black, for: .normal)
            self?.bleBtn.setTitleColor(UIColor("#cecece"), for: .normal)
            self?.underLine.transform = CGAffineTransform.init(translationX: mScreenW / 2, y: 0)
            
            self?.viewModel.rx_authType.value = 1
            self?.tableView.mj_header.beginRefreshing()

        }).disposed(by: rx.disposeBag)
        
        
        viewModel.rx_lockList.asDriver()
            .drive(tableView.rx.items(cellIdentifier: R.reuseIdentifier.tapplockListCellIdenty.identifier, cellType: TappLockListCell.self)) {
                (indexPath, model, cell) in
                cell.model = model
                
        }.disposed(by: rx.disposeBag)
        
        
        tableView.rx.modelSelected(TapplockModel.self).subscribe(onNext: { [weak self] model in
             TapplockManager.default.editingLock = model
            if self?.isBLE == true {
                self?.performSegue(withIdentifier: R.segue.myTapplockController.showBLELockDetail, sender: self)
            } else {
                self?.performSegue(withIdentifier: R.segue.myTapplockController.showFingerLockDetail, sender: self)
            }
        }).disposed(by: rx.disposeBag)
        

        tableView.mj_header  = RefreshGifheader.init { [weak self] in
            self?.viewModel.loadRefresh()
        }

        tableView.mj_footer = FooterRefresh.init(refreshingBlock: { [weak self] in
            self?.viewModel.loadMore()
        })

        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.mj_footer.endRefreshing()
                switch step {
                case .errorMessage(let mesg):
                    self?.showToast(message: mesg)
                default:
                    break
                }
            
        }).disposed(by: rx.disposeBag)
        
        viewModel.rx_loadAll.asDriver()
            .drive(onNext: { [weak self] all in
                
                if all {
                    self?.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self?.tableView.mj_footer.resetNoMoreData()
                }
            }).disposed(by: rx.disposeBag)
        
        
        
        let instructionKey = String(describing: type(of: self))
        let instruction: Bool? = UserDefaults.standard.bool(forKey: instructionKey)
        if instruction == nil || !instruction! {
            UserDefaults.standard.set(true, forKey: instructionKey)
            self.coachMarksController.overlay.color = UIColor.overLayColor
            self.coachMarksController.overlay.allowTap = true
            self.coachMarksController.dataSource = self
            self.coachMarksController.delegate = self
            self.coachMarksController.start(on: self)
        } else {
            self.viewModel.loadAPI()
        }
        
    }
    
    @IBAction func rightSearchAction(_ sender: Any) {
        
        self.searchBar?.serchShow()
        self.hiddenMenu()
        
        searchBar?.rx_text.asDriver().drive(viewModel.rx_lockName).disposed(by: rx.disposeBag)
        searchBar?.rx_action.asObservable()
            .subscribe(onNext: { [weak self] bl in
               
                if bl {
                    self?.tableView.mj_header.beginRefreshing()
                } else {
                    self?.viewModel.rx_lockName.value = nil
                }
        }).disposed(by: rx.disposeBag)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if viewModel.rx_lockName.value != nil, viewModel.rx_lockName.value?.length != 0 {
            self.searchBar?.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if viewModel.rx_lockName.value?.length == 0 || viewModel.rx_lockName.value == nil {
            self.searchBar?.cancelHidde()
        } else  {
            self.searchBar?.isHidden = true
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        plog("tapplock 销毁了")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vm = R.segue.myTapplockController.showUserGroupSegue(segue: segue) {
            vm.destination.block = { [weak self] model in
                self?.groupLab.text = model.groupName
                self?.viewModel.rx_groupId.value = model.id
                self?.tableView.mj_header.beginRefreshing()
            }
        }
        
    }
   
}


//指南实现拓展
extension MyTapplockController: CoachMarksControllerDelegate,CoachMarksControllerDataSource {
    func coachMarksController(_ coachMarksController: CoachMarksController,
                              didHide coachMark: CoachMark,
                              at index: Int){
        if index == 4 {
            //本页指南完成后,加载所列表.
            self.viewModel.loadAPI()
        }
    }
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var hintText: String
        switch index {
        case 0:
            hintText = R.string.localizable.instructionsMenu()
        case 1:
            hintText = R.string.localizable.instructionsMenu()
        case 2:
            hintText = R.string.localizable.instructionsMenu()
        case 3:
            hintText = R.string.localizable.instructionsMenu()
        default:
            hintText = R.string.localizable.instructionsMenu()
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true,
                                                                           arrowOrientation: coachMark.arrowOrientation,
                                                                           hintText: hintText,
                                                                           nextText: nil)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        case 0:
            return coachMarksController.helper.makeCoachMark(for: menuBtn.value(forKey: "view") as? UIView)
        case 1:
            return coachMarksController.helper.makeCoachMark(for: searchBtn.value(forKey: "view") as? UIView)
        case 2:
            return coachMarksController.helper.makeCoachMark(for: bleBtn)
        case 3:
            return coachMarksController.helper.makeCoachMark(for: fingerBtn)
        default:
            return coachMarksController.helper.makeCoachMark(for: groupLab)
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 5
    }
    
    
}
