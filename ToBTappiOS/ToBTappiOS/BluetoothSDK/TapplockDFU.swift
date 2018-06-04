//
//  TapplockDFU.swift
//  ToBTapplcok
//
//  Created by TapplockiOS on 2018/4/27.
//  Copyright © 2018年 TapplockiOS. All rights reserved.
//

//import Foundation
//import CoreBluetooth
//import iOSDFULibrary
//import RxCocoa
//import RxSwift
//
//protocol DFUTargetType{
//    var manager: CBCentralManager { get }
//    var perpheral: CBPeripheral { get set }
//    var url: URL { get set }
//
//}
//
//class DFUClient: DFUServiceDelegate, DFUProgressDelegate {
//
//    var dfuState: BehaviorRelay<DFUState> = BehaviorRelay(value: .connecting)
//    var dfuPorgress: BehaviorRelay<Float> = BehaviorRelay(value: 0)
//    var dfuController: DFUServiceController?
//
//
//    func sendDFU<M: DFUTargetType>(_ r: M){
//
//        let firmware = DFUFirmware(urlToZipFile: r.url, type: .softdeviceBootloaderApplication)
//        let initiator = DFUServiceInitiator(centralManager: r.manager, target: r.perpheral)
//        initiator.forceDfu = false
//        initiator.packetReceiptNotificationParameter = 12
//        initiator.delegate = self
//        initiator.progressDelegate = self
//        initiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = true
//        self.dfuController = initiator.with(firmware: firmware!).start()
//    }
//
//    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
//
//    }
//    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
//        let fl = Float(progress) / 100
//        self.dfuPorgress.accept(fl)
//    }
//    func dfuStateDidChange(to state: DFUState) {
//        self.dfuState.accept(state)
//    }
//}
