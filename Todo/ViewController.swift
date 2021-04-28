//
//  ViewController.swift
//  Todo
//
//  Created by mac on 21/04/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    var items = [String]( )
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        title = "Todo"
        view.addSubview(table)
        table.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "New Item", message: "Do you want to add a new item to the list", preferredStyle: .alert)
        alert.addTextField{ field in
            field.placeholder = "Enter item...."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {_ in
            if let field = alert.textFields?.first{
                if let text = field.text, !text.isEmpty {
                    //enter a list item
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self.items.append(text)
                        self.table.reloadData()
                    }
                    
                }
            }
        } ))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

