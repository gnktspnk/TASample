//
//  CoreDataManager.swift
//  TASample
//
//  Created by Gennadii Tsypenko on 17/11/2018.
//  Copyright © 2018 Gennadii Tsypenko. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func save(restaurantDataModel: RestaurantDataModel) -> CDRestaurant? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let restaurant = CDRestaurant(context: managedContext)
        restaurant.name = restaurantDataModel.name
        restaurant.status = restaurantDataModel.status
        
        
        if let sortingValuesData = restaurantDataModel.sortingValues {
            let sortingValues = CDRestaurantSortingValues(context: managedContext)
            sortingValues.bestMatch = sortingValuesData.bestMatch
            sortingValues.newest = sortingValuesData.newest
            sortingValues.ratingAverage = sortingValuesData.ratingAverage
            sortingValues.distance = sortingValuesData.distance
            sortingValues.popularity = sortingValuesData.popularity
            sortingValues.averageProductPrice = Int32(sortingValuesData.averageProductPrice)
            sortingValues.deliveryCosts = Int32(sortingValuesData.deliveryCosts)
            sortingValues.minCost = Int32(sortingValuesData.minCost)
            
            restaurant.sortingValues = sortingValues
        }
        
        
        do {
            try managedContext.save()
            return restaurant
        } catch let error as NSError {
            print("couldn't save, error: \(error.description)")
        }
        return nil
    }
    
    func delete(managedObjectToDelete: CDRestaurant) -> CDRestaurant? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        managedContext.delete(managedObjectToDelete)
        
        do {
            try managedContext.save()
            return managedObjectToDelete
        } catch let error as NSError {
            print("couldn't delete, error: \(error.description)")
        }
        return nil
    }
    
    func fetchAllFavouritesFromStorage() -> [CDRestaurant]? {
        let managedContext = CoreDataManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<CDRestaurant>(entityName: "CDRestaurant")
        
        do {
           let favouriteRestaurants = try managedContext.fetch(fetchRequest)
           return favouriteRestaurants
        } catch let error as NSError {
            print("couldn't fetch, error: \(error.description)")
        }
        return nil
    }
    
   
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "TASample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
