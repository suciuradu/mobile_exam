//
//  ViewController.swift
//  MobileExam
//
//  Created by Suciu Radu on 07/02/2019.
//  Copyright © 2019 Team. All rights reserved.
//

import UIKit
import IHProgressHUD
import Starscream
import BRYXBanner

class MainViewController: UIViewController {
    
    @IBOutlet weak var orderTableView: UITableView!
    @IBOutlet weak var internetStatus: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var selectedItemTextField: UITextField!
    
    var selectedItem: MenuItem?
    private let socketService = SocketService<MenuItem>()
    var viewModel: MainViewModel!
    var menuItemArray = [MenuItem]()
    var table = 1
    var myOrders = [OrderItem]()
    var timer: Timer!
    var toBeSent = [OrderItem]()
    var orderNotSent: OrderItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initViewModel()
        listenToWebSocket()
    }
    
    private func initUI() {
        hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        orderTableView.dataSource = self
        orderTableView.delegate = self
        searchBar.delegate = self
        orderTableView.reloadData()
        searchBar.autocapitalizationType = .none
        self.myOrders.removeAll()
        self.myOrders = PersistancyManager.getAllOrders() ?? []
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkConnection), userInfo: nil, repeats: true)

    }
    
    @objc func checkConnection() {
        if Reachability.isConnectedToNetwork() {
            internetStatus.text = "Online"
            internetStatus.textColor = UIColor.green
            if toBeSent.count > 0 {
                for item in toBeSent {
                    viewModel.postOrder(order: item)
//                    orderTableView.reloadData()
                }
                toBeSent.removeAll()
            }
        } else {
            internetStatus.text = "Disconnected"
            internetStatus.textColor = UIColor.red
        }
    }
    
    private func initViewModel() {
        viewModel.menuItem.bind { (menu) in
            if menu.isEmpty {
                if Reachability.isConnectedToNetwork() {
                    self.menuItemArray.removeAll()
                    self.tableView.reloadData()
                } else {
                    self.showErrorMessage("Something went wrong!")
                }
            } else {
                IHProgressHUD.dismiss()
                let menuSliced = Array(menu.prefix(5))
                var history = [MenuItem]()
                history = PersistancyManager.getAll() ?? []
                history.append(contentsOf: menuSliced)
                PersistancyManager.shared.set(model: history)
                self.menuItemArray.removeAll()
                self.menuItemArray.append(contentsOf: menuSliced)
                self.tableView.reloadData()
            }
        }
        viewModel.orderSuccess.bind { (success) in
            if success {
                self.showSuccessMessage("Order posted!")
                self.selectedItemTextField.text = ""
                self.quantityTextField.text = ""
                self.selectedItem = nil
            } else {
                self.toBeSent.append(self.orderNotSent!)
                self.showErrorMessage("We can't process your order! Try when connection is up!")
            }
        }
        
        viewModel.order.bind { (order) in
            if let item = order {
                var orders = [OrderItem]()
                orders = PersistancyManager.getAllOrders() ?? []
                orders.append(item)
                self.myOrders.removeAll()
                self.myOrders.append(contentsOf: orders)
                PersistancyManager.shared.setOrder(model: self.myOrders)
                Logger.log("count order", self.myOrders.count)
                self.orderTableView.reloadData()
            }
            
        }
    }
    
    private func listenToWebSocket() {
        socketService.didRecieveObject = { object in
            let banner = Banner(title: "Special Offer", subtitle: object.name, image: UIImage(named: "info"), backgroundColor: #colorLiteral(red: 0.1176470588, green: 0.7176470588, blue: 0.6901960784, alpha: 1))
            banner.dismissesOnTap = true
            banner.didTapBlock = {
                let orderItem = OrderItem()
                orderItem.quantity = 1
                orderItem.code = object.code
                orderItem.free = true
                self.viewModel.postOrder(order: orderItem)
            }
            
            banner.show(duration: 3.0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        checkConnection()
    }
    
    @IBAction func orderItemTapped(_ sender: Any) {
        let orderItem = OrderItem()
        if let quanity = quantityTextField.text {
            orderItem.quantity = Int(quanity)
        }
        if let order = selectedItem {
            orderItem.code = order.code
            orderItem.free = false
        }
        orderNotSent = orderItem
        viewModel.postOrder(order: orderItem)
        
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                if searchText != "" && searchText != " " {
                    self.viewModel.getMenuItems(querry: searchText)
                    IHProgressHUD.show()
                } else {
                    self.menuItemArray.removeAll()
                    self.tableView.reloadData()
                }
            })
        } else {
            self.menuItemArray.removeAll()
            self.menuItemArray.append(contentsOf: getListFromQuerry(querry: searchText))
            self.tableView.reloadData()
        }
    }
    
    private func getListFromQuerry(querry: String) -> [MenuItem] {
        var items = [MenuItem]()
        items = PersistancyManager.getAll() ?? []
        
        let filteredStrings = items.filter({(item: MenuItem) -> Bool in
            
            let stringMatch = item.name!.range(of: querry.lowercased())
            return stringMatch != nil ? true : false
        })
        return filteredStrings
    }
}


// TABLE VIEW DELEGATE, DATASOURCE
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView != orderTableView {
            if menuItemArray.count == 0 {
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
            }
            return menuItemArray.count
        } else {
            return myOrders.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = menuItemArray[indexPath.row]
        if let name = selectedItem?.name {
            selectedItemTextField.text = name
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView != orderTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TableViewCell else {return UITableViewCell()}
            cell.titleLabel.text = menuItemArray[indexPath.row].name
            return cell
        } else {
            guard let cell = orderTableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell else {return UITableViewCell()}
            cell.titleOrderLabel.text = "Code: \(myOrders[indexPath.row].code ?? 1) and Quantity: \(myOrders[indexPath.row].quantity ?? 10) - Free: \(myOrders[indexPath.row].free ?? false)"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.6
    }
}

//TABLE VIEW CELL CLASS
class TableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
}

class OrderCell: UITableViewCell {
    @IBOutlet weak var titleOrderLabel: UILabel!
}
