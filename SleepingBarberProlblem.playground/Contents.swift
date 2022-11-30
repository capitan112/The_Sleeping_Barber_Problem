import UIKit
import Foundation

protocol Lock {
    func lock()
    func unlock()
}

final class Mutex: Lock {
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()
    
    func lock() {
        pthread_mutex_lock(&mutex)
    }
    
    func unlock() {
        pthread_mutex_unlock(&mutex)
    }
}


var totalSeats: Int = 3
let seatsMutex = Mutex()
let customerSemaphore = DispatchSemaphore(value: 0)
let barber = DispatchSemaphore(value: 0)
let client = DispatchSemaphore(value: 0)
let seatsBelt = DispatchSemaphore(value: 0)

let barberQueue = DispatchQueue(label: "com.barberQueue", attributes: .concurrent)

let secondBarberQueue = DispatchQueue(label: "com.barberQueue", attributes: .concurrent)

let clientsQueue = DispatchQueue(label: "com.clientsQueue", attributes: .concurrent)
let addditionalClientsQueue = DispatchQueue(label: "com.addditionalClientsQueue", attributes: .concurrent)
let addditionalClientsQueue_2 = DispatchQueue(label: "com.addditionalClientsQueue_2", attributes: .concurrent)
let addditionalClientsQueue_3 = DispatchQueue(label: "com.addditionalClientsQueue_3", attributes: .concurrent)


func barber(index: Int) {
    while true {
        customerSemaphore.wait()
        sleep(1)
        seatsMutex.lock()
        print("Barber with index \(index) ready to take client")
        barber.signal()
        totalSeats += 1
        seatsMutex.unlock()
        client.wait()
        print("Barber with index \(index) starting cut hairs")
        sleep(3)
        seatsBelt.signal()
    }
}

func clients(index: Int) {
    seatsMutex.lock()
    print("Client with index \(index) arrived")
    if totalSeats > 0 {
        totalSeats -= 1
        print("Total available seats: \(totalSeats)")
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


barberQueue.async {
    barber(index: 1)
}

secondBarberQueue.async {
    barber(index: 2)
}

clientsQueue.async {
    sleep(1)
    for client in 0..<10 {
        clients(index: client)
    }
}

addditionalClientsQueue.async {
    sleep(2)
    for client in 11..<20 {
        clients(index: client)
    }
}

addditionalClientsQueue_2.async {
    sleep(2)
    for client in 21..<30 {
        clients(index: client)
    }
}

addditionalClientsQueue_3.async {
    sleep(1)
    for client in 31..<40 {
        clients(index: client)
    }
}
