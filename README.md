# The Sleeping Barber Problem

Dijkstra introduced the sleeping barber problem in 1965. This problem is based on a hypothetical scenario where there is a barbershop with one barber. The barbershop is divided into two rooms, the waiting room, and the workroom. The waiting room has n chairs for waiting customers, and the workroom only has a barber chair.
Now, if there is no customer, then the barber sleeps in his own chair(barber chair). Whenever a customer arrives, he has to wake up the barber to get his haircut. If there are multiple customers and the barber is cutting a customer's hair, then the remaining customers wait in the waiting room with "n" chairs(if there are empty chairs), or they leave if there are no empty chairs in the waiting room.
The sleeping barber problem may lead to a race condition. This problem has occurred because of the actions of both barber and customer.

Implementations in Swift with Mutex.
