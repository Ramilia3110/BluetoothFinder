//
//  ViewController.swift
//  BluetoothFinder
//
//  Created by Ramilia Imankulova on 12/14/18.
//  Copyright © 2018 Ramilia Imankulova. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate {
    //MARK: - Properties
    
    var centralManager: CBCentralManager?
    var names: [String] = []
    var RSSIs:[NSNumber] = []
    var timer: Timer?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    //MARK: - Actions

    @IBAction func refreshTapped(_ sender: Any) {
        startScan()
        startTimer()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { (timer) in
            self.startScan()
        })
    }
    
    func startScan() {
        names = []
        RSSIs = []
        tableView.reloadData()
        centralManager?.stopScan()
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
   
    //MARK: - CBCentralManager Code
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name {
            names.append(name)
        } else {
            names.append(peripheral.identifier.uuidString)
        }
        RSSIs.append(RSSI)
        tableView.reloadData()
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            //Working
            startScan()
            startTimer()
        } else {
            //Not working
            let alertVC = UIAlertController(title: "Bluetoth isn't working", message: "Make sure your bluetooth is on", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alertVC.dismiss(animated: true, completion: nil)
            })
            alertVC.addAction(action)
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    //MARK:  - TableView Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "bluetoothCell", for: indexPath) as? BluetoothCell {
            cell.nameLbl.text = names[indexPath.row]
            cell.rssiLbl.text = "RSSI: \(RSSIs[indexPath.row])"
            return cell
        } else {
        
        return UITableViewCell()
        }
    }
    
}

