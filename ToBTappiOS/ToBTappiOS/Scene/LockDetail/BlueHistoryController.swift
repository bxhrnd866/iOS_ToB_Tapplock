//
//  BlueHistoryController.swift
//  ToBTappiOS
//
//  Created by TapplockiOS on 2018/6/19.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Instructions
class BlueHistoryController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var data = Variable(["22","333","22","333","22","333","22","333","22","333"])
    
    @IBOutlet weak var dateBtn: UIBarButtonItem!
    
    let viewModel = LockHistoryViewModel(type: 1)
     let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        tableview.mj_header  = RefreshGifheader.init { [weak self] in
            self?.viewModel.loadRefresh()
        }
        
        tableview.mj_footer = FooterRefresh.init(refreshingBlock: { [weak self] in
            self?.viewModel.loadMore()
        })
        
        viewModel.rx_step
            .asObservable()
            .subscribe(onNext: { [weak self] step in
                self?.tableview.mj_header.endRefreshing()
                self?.tableview.mj_footer.endRefreshing()
                self?.tableview.reloadData()
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
                    self?.tableview.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    self?.tableview.mj_footer.resetNoMoreData()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = R.segue.blueHistoryController.showHistoryDate(segue: segue) {
            vc.destination.block = { [weak self] tuple in
                self?.viewModel.rx_beginTime.value = tuple.0
                self?.viewModel.rx_endTime.value = tuple.1
                self?.tableview.mj_header.beginRefreshing()
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)       
     
    }
    
    deinit {
        plog("销毁了")
    }
}

extension BlueHistoryController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
        
        return source ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let key = [String](viewModel.dictSource.keys)[indexPath.section]
        let source = viewModel.dictSource[key]!
        let model = source[indexPath.row]
        
        let height = model.cellHeight ?? 20
        return 100 + height
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dictSource.keys.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIndenty) as? HistoryTableHeaderView
        if header == nil {
            header = HistoryTableHeaderView(reuseIdentifier: headerIndenty)
        }
        
        let key = [String](viewModel.dictSource.keys)[section]
        let source = viewModel.dictSource[key]?.count
        
        header?.labItems?.text = "\(source ?? 0) items"
        header?.labTime?.text = key
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 26
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.blueLockDetailIdentyCell.identifier , for: indexPath) as! BlueLockDetailCell
        
        let key = [String](viewModel.dictSource.keys)[indexPath.section]
        let source = viewModel.dictSource[key]!
        cell.model = source[indexPath.row]
        
        
        return cell
    }
    
}
//指南实现拓展
extension BlueHistoryController: CoachMarksControllerDelegate,CoachMarksControllerDataSource {
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        var hintText: String
        switch index {
        default:
            hintText = R.string.localizable.instructionDateSelct()
        }
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true,
                                                                           arrowOrientation: coachMark.arrowOrientation,
                                                                           hintText: hintText,
                                                                           nextText: nil)
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        switch index {
        
        default:
            return coachMarksController.helper.makeCoachMark(for: dateBtn.value(forKey: "view") as? UIView)
        }
    }
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 1
    }
    
    
}


