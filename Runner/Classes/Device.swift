//
//  Device.swift
//  Runner
//
//  Created by Khanh Pham on 3/23/17.
//  Copyright © 2017 Khanh Pham. All rights reserved.
//

import Foundation
import CoreBluetooth
import RxBluetoothKit

class Device {
    var name: String?
    var serialNumber: String?
    var rssi: Int?
    var peripheral: Peripheral?
}

private extension Device {
    static func from(scannedPeripherial: ScannedPeripheral) -> Device {
        let rs = Device()
        rs.rssi = scannedPeripherial.rssi.intValue
        rs.peripheral = scannedPeripherial.peripheral
        String.init(data: scannedPeripherial.advertisementData.manufacturerData!, encoding: String.Encoding.utf8)
        rs.name = scannedPeripherial.advertisementData.localName
        return rs
    }
}

/**
 Device services. Format: 3ddaXXXX-957f-7d4A-34a6-74696673696d
 */
enum DeviceService: String, ServiceIdentifier {
    
    case mp = "3dda0001-957f-7d4A-34a6-74696673696d"
    
    var uuid: CBUUID {
        return CBUUID(string: self.rawValue)
    }
    
}

enum DeviceCharacteristic: String, CharacteristicIdentifier {
    case manufacturerName = "2A29"
    
    case dc = "3dda0002-957f-7d4A-34a6-74696673696d"
    case ftc = "3dda0003-957f-7d4A-34a6-74696673696d"
    case ftd = "3dda0004-957f-7d4A-34a6-74696673696d"
    
    var uuid: CBUUID {
        return CBUUID(string: self.rawValue)
    }
    
    //Service to which characteristic belongs
    var service: ServiceIdentifier {
        return DeviceService.mp
    }
}

class BLEService {
    private let queue: DispatchQueue
    private let manager: BluetoothManager
    
    init() {
        queue = DispatchQueue(label: "BLEServiceQueue")
        manager = BluetoothManager(queue: queue)
    }
    
    var state: Observable<BluetoothState> {
        return manager.rx_state
    }
    
    func scanDevices() -> Observable<Device> {
        return prepareManager()
            .flatMap { self.manager.scanForPeripherals(withServices: [DeviceService.mp.uuid]) }
                .map { Device.from(scannedPeripherial: $0) }
        
    }
    
    private func prepareManager() -> Observable<Void> {
        return manager.rx_state
            .filter { $0 == .poweredOn }
            .timeout(3.0, scheduler: MainScheduler.instance)
            .take(1)
            .map { _ in () }
    }
}
