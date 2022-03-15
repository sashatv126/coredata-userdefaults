//
//  ViewController.swift
//  M20
//
//  Created by Владимир on 14.03.2022.
//

import UIKit
import CoreData
enum Keys {
    static let sort = "sort"
}
struct  User : Codable {
    var sort : Int?
}

class TableViewController: UITableViewController {
//MARK: -Properties
    private var savedSort : User = User()
    private let cellid = "coreDataCell"
    private var flag = true
    private let persistantContainer = NSPersistentContainer(name: "Model")
   private let req: NSFetchRequest<Entity> = Entity.fetchRequest()
   private lazy var fetchResulController : NSFetchedResultsController<Entity> = {
        let fetchController = NSFetchedResultsController(fetchRequest: req, managedObjectContext: self.persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchController.delegate = self
        return fetchController
    }()
//MARK: -Views
    override func viewDidLoad() {
        super.viewDidLoad()
        userSort()
        load()
        setupViews()
        setupDelegate()
    }
//MARK: Override methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResulController.sections?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = fetchResulController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = data.name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResulController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = fetchResulController.object(at: indexPath)
            persistantContainer.viewContext.delete(data)
            try? persistantContainer.viewContext.save()
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AddViewController()
        vc.data = fetchResulController.object(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
//MARK: -Privat methods
    private func userSort()  {
        if let data = UserDefaults.standard.data(forKey: Keys.sort) {
            savedSort = (try? JSONDecoder().decode(User.self, from: data)) ?? User()
        }
        switch savedSort.sort {
        case 1: let sortDescriptor = NSSortDescriptor(key:"lastName", ascending: true,selector: #selector(NSString.localizedCaseInsensitiveCompare))
            req.sortDescriptors = [sortDescriptor]
        case 2: let sortDescriptor = NSSortDescriptor(key:"lastName", ascending: false,selector: #selector(NSString.localizedCaseInsensitiveCompare))
            req.sortDescriptors = [sortDescriptor]
        default: let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            req.sortDescriptors = [sortDescriptor]
            
        }
    }
    private func load() {
        persistantContainer.loadPersistentStores{(persistantStoreDescription, error) in if let error = error {
            print("not load")
            print("\(error), \(error.localizedDescription)")
        }
        else {
            do {
                try self.fetchResulController.performFetch()
            } catch  {
                print(error.localizedDescription)
            }
        }
    }
}
    private func setupViews() {
        view.backgroundColor = .white
        let plus = cCB(selector: #selector(bb))
        navigationItem.rightBarButtonItem = plus
        let plus1 = cBC(selector: #selector(termit))
        navigationItem.leftBarButtonItem = plus1
    }
    private func setupDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    @objc private func bb() {
        let vc = AddViewController()
        vc.data = Entity.init(entity: NSEntityDescription.entity(forEntityName: "Entity", in: self.persistantContainer.viewContext)!, insertInto: self.persistantContainer.viewContext)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func termit() {
        if flag {
            savedSort.sort = 1
            if let data = try? JSONEncoder().encode(savedSort) {
                UserDefaults.standard.set(data, forKey: Keys.sort)
            }
            let sortDescriptor = NSSortDescriptor(key:"lastName", ascending: true,selector: #selector(NSString.localizedCaseInsensitiveCompare))
            fetchResulController.fetchRequest.sortDescriptors = [sortDescriptor]
            try? fetchResulController.performFetch()
            tableView.reloadData()
            flag = false
        }
        else {
            savedSort.sort = 2
            if let data = try? JSONEncoder().encode(savedSort) {
                UserDefaults.standard.set(data, forKey: Keys.sort)
            }
            let sortDescriptors = NSSortDescriptor(key:"lastName", ascending: false,selector: #selector(NSString.localizedCaseInsensitiveCompare))
            fetchResulController.fetchRequest.sortDescriptors = [sortDescriptors]
            try? fetchResulController.performFetch()
            tableView.reloadData()
            flag = true
        }
        
    }
}
//MARK: -Extension
extension TableViewController : NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let data = fetchResulController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.text = data.name
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move :
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
}
