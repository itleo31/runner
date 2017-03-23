//
//  AddDeviceTableViewController.swift
//  Runner
//
//  Created by Khanh Pham on 3/23/17.
//  Copyright © 2017 Khanh Pham. All rights reserved.
//

import UIKit
import RxDataSources

class DeviceCell: UITableViewCell {
    var device: Device? {
        didSet {
            if let device = device {
                textLabel?.text = device.name
                detailTextLabel?.text = device.serialNumber
            } else {
                textLabel?.text = nil
                detailTextLabel?.text = nil
            }
        }
    }
}

class AddDeviceTableViewController: UITableViewController {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    let logger = ComponentsFactory.logger
    let loading = ComponentsFactory.loadingIndicator
    let bleService = ComponentsFactory.bleService
    
    let disposedBag = DisposeBag()
    
    var devices: [Device] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshButton.rx.tap.asObservable()
            .observeOnMain()
            .bindNext { [unowned self] in
                self.scanDevices()
            }
            .addDisposableTo(disposedBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Events
    
    func scanDevices() {
        loading.show()
        bleService.scanDevices()
            .timeout(30, scheduler: MainScheduler.instance)
            .observeOnMain()
            .scan([], accumulator: { $0.appending($1) })
            .subscribe({ [unowned self] (event) in
                switch event {
                case .next(let devices):
                    self.reload(withDevices: devices)
                case .error(let error):
                    self.logger.logError("Failed to scan: " + error.localizedDescription)
                    self.loading.dismiss()
                case .completed:
                    self.loading.dismiss()
                }
                
            })
            .addDisposableTo(disposedBag)
    }
    
    func reload(withDevices devices: [Device]) {
        self.devices = devices
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! DeviceCell
        
        cell.device = devices[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
