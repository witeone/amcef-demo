//
//  Repository.swift
//  polak.amcef.demo
//
//  Created by Marek Polak on 17/02/2023.
//

import Foundation
import CoreData
import Combine

class Repository<Entity: NSManagedObject> {
    private var context = PersistenceController.shared.viewContext

    func fetch(sortDesc: [NSSortDescriptor] = [], predicate: NSPredicate? = nil) -> AnyPublisher<[Entity], Error> {
        Deferred { [context] in
            Future { promise in
                context?.perform {
                    let request = Entity.fetchRequest()
                    request.sortDescriptors = sortDesc
                    request.predicate = predicate

                    do {
                        let results = try context?.fetch(request) as! [Entity]
                        promise(.success(results))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func add(_ body: @escaping (inout Entity) -> Void) -> AnyPublisher<Entity, Error> {
        Deferred { [context] in
            Future  { promise in
                guard let context else { return promise(.failure(CDError.noContext)) }

                context.perform {
                    var entity = Entity(context: context)
                    body(&entity)
                    do {
                        try context.save()
                        promise(.success(entity))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteAll() -> AnyPublisher<Void, Error> {
        Deferred { [context] in
            Future { promise in
                context?.perform {
                    do {
                        let request = Entity.fetchRequest()
                        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                        try context?.execute(batchDeleteRequest)
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
