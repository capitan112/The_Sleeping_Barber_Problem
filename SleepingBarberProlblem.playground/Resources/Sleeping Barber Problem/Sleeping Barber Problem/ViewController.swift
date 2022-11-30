//
//  ViewController.swift
//  Sleeping Barber Problem
//
//  Created by Oleksiy Chebotarov on 10/11/2022.
//

import UIKit

class ViewController: UIViewController {
    var totalSeats: Int = 2
    let seatsMutex = Mutex()
    let customerSemaphore = DispatchSemaphore(value: 0)
    let barber = DispatchSemaphore(value: 0)
    let client = DispatchSemaphore(value: 0)
    let seatsBelt = DispatchSemaphore(value: 0)
    
    let barberQueue = DispatchQueue(label: "com.barberQueue", attributes: .concurrent)
    let clientsQueue = DispatchQueue(label: "com.clientsQueue", attributes: .concurrent)
    let addditionalClientsQueue = DispatchQueue(label: "com.addditionalClientsQueue", attributes: .concurrent)
    let addditionalClientsQueue_2 = DispatchQueue(label: "com.addditionalClientsQueue_2", attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barberQueue.async {
            self.barber(index: 1)
        }
        
        clientsQueue.async {
            for client in 0..<10 {
//                sleep(1)
                self.clients(index: client)
            }
        }
        
        addditionalClientsQueue.async {
            for client in 11..<20 {
                self.clients(index: client)
            }
        }
        
        addditionalClientsQueue_2.async {
            for client in 21..<30 {
                self.clients(index: client)
            }
        }

    }
    
    func barber(index: Int) {
        while true {
            customerSemaphore.wait()
            seatsMutex.lock()
            print("Barber with index \(index) ready to take client")
            barber.signal()
            totalSeats += 1
            seatsMutex.unlock()
            client.wait()
            print("Barber with index \(index) starting cut hairs")
//            sleep(3)
            seatsBelt.signal()
        }
    }
    
    func clients(index: Int) {
        seatsMutex.lock()
        print("Client with index \(index) arrived")
        if totalSeats > 0 {
            totalSeats -= 1
            print("Total seats: \(totalSeats)")
            customerSemaphore.signal()
            seatsMutex.unlock()
            
            barber.wait()
            print("Client with index \(index) starting seating")
            client.signal()
            seatsBelt.wait()
            print("Client with index \(index) unlocked and go away")
        } else {
            
            print("Client with index \(index) go away. No empty seats")
            seatsMutex.unlock()
        }
    }


}




