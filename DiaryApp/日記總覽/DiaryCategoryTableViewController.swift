//
//  DiaryCategoryTableViewController.swift
//  DiaryApp
//
//  Created by EthanLin on 2018/1/23.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreData

class DiaryCategoryTableViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    
    
    //讀取CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let diary = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
    
    //連結Code Data Model到viewController
    //Step 1:Creating a Fetched Results Controller
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    func initializeFetchedResultsController() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Diary")
        let sortByContent = NSSortDescriptor(key: "diaryContent", ascending: false)
        request.sortDescriptors = [sortByContent]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeFetchedResultsController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //Step2: Integrating the Fetched Results Controller with the Table View Data Source讓資料顯示在tableView中
    func configureCell(cell: UITableViewCell, indexPath: IndexPath){
        let diary  = fetchedResultsController.object(at: indexPath) as! Diary
        let cell = cell as! DiaryCategoryTableViewCell
        
        //entry處理
        cell.partContentLabel.text = diary.diaryContent
        
        if let okPhoto = diary.diaryImage{
            cell.imageView?.image = UIImage(data: okPhoto as Data)
        }
        
    }
    

  

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCategoryCell", for: indexPath) as! DiaryCategoryTableViewCell
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
        
        //Populate the cell from the object
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }


    //Communicating Data Changes to the Table View
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    // 可以編輯tableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // delete from coreData
        let managedObject = fetchedResultsController.object(at: indexPath) as! NSManagedObject
        context.delete(managedObject)
        
        //saveChanges
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
