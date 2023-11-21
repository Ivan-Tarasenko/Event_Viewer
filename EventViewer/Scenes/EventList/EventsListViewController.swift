//
//  EventsListViewController.swift
//  EventViewer
//
//  Created by Ilya Kharlamov on 1/26/23.
//

import UIKit

class EventsListViewController: UITableViewController {
    
    // MARK: - Outlets
    private lazy var logoutBarButtonItem = UIBarButtonItem(
        title: "Logout",
        style: .plain,
        target: self,
        action: #selector(EventsListViewController.logout)
    )
    
    private lazy var addEventBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "plus"),
        style: .plain,
        target: self,
        action: #selector(EventsListViewController.addEvent)
    )
    
    private lazy var clearBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "trash"),
        style: .plain,
        target: self,
        action: #selector(EventsListViewController.cleanList)
    )
    
    
    private lazy var refresh = UIRefreshControl()
    private lazy var searchController = UISearchController()
    
    // MARK: - Variables
    
    private var countLoadData: Int = 0
    private var viewModel: EventListModelProtorol!
    private let eventManager: EventManager
    private let dataSource: TableViewDataSource
    private let delegate: TableViewDelegate
    private let auxiliaryFunctions = AuxiliaryFunctions.shared
    
    // MARK: - Lifecycle
    init(eventManager: EventManager, dataSourse: TableViewDataSource, delegate: TableViewDelegate) {
        self.eventManager = eventManager
        self.dataSource = dataSourse
        self.delegate = delegate
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel  = EventListViewModel(eventManager: eventManager)
        uploadData()
        configureUI()
        bing()
        setupSearchController()
        tapCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventManager.capture(.viewScreen("EVENTS_LIST"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    // MARK: - Configuration
    
    private func configureUI() {
        navigationItem.title = "Events List"
        navigationItem.rightBarButtonItems = [self.logoutBarButtonItem, self.clearBarButtonItem]
        navigationItem.leftBarButtonItem = self.addEventBarButtonItem
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        refresh.addTarget(self, action: #selector(updateTable), for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    private func bing() {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        dataSource.viewModel = viewModel
    }
    
    // MARK: - Actions
    
    @objc
    private func logout() {
        eventManager.capture(.logout)
        let vc = LoginViewController(eventManager: eventManager)
        
        vc.onReloadData = { [weak self] in
            guard let self else { return }
            self.reloadData()
        }
        
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    @objc
    private func addEvent() {
        
        let AddEventVC = AddEventViewController(
            dataSource: AddEventDataSource(),
            delegate: AddEventDelegate()
        )
        
        AddEventVC.eventManager = self.eventManager
        
        AddEventVC.onReloadData = { [weak self] in
            guard let self else { return }
            self.reloadData()
        }
        
        let navVC = UINavigationController(rootViewController: AddEventVC)
        navVC.modalPresentationStyle = .fullScreen
        
        self.present(navVC, animated: true)
    }
    
    @objc
    private func cleanList() {
        auxiliaryFunctions.showAlertClear (
            on: self,
            title: R.TitleAlertClear.titleClear,
            massage: R.TitleAlertClear.massageClear
        ) {
            self.eventManager.clean { error in
                if (error != nil) {
                    print(error.debugDescription)
                    return
                }
                self.reloadData()
            }
        }
    }
    
    @objc
    private func updateTable() {
        reloadData()
        refresh.endRefreshing()
    }
    
    private func tapCell() {
        delegate.onTapCell = { [weak self] index in
            guard let self else { return }
            
            guard !self.viewModel.limitAllEvents.isEmpty else { return }
            
            let detailVC = DetailEventViewController(
                dataSource: DetailEventDataSource(),
                delegate: DetailEventDelegate()
            )
            
            detailVC.indexCell = index
            detailVC.eventManager = self.eventManager
            
            let navVC = UINavigationController(rootViewController: detailVC)
            navVC.modalPresentationStyle = .fullScreen
            
            self.present(navVC, animated: true)
            
        }
    }
    
    // MARK: - Additional functions
    private func uploadData() {
        delegate.onScrollAction = { [weak self] in
            guard let self else { return }
            
            self.eventManager.getLimitEvents(n: self.countLoadData)
            self.viewModel.limitAllEvents = self.eventManager.limitEvents
            
            if self.countLoadData < self.viewModel.limitAllEvents.count {
                self.countLoadData += 5
                self.tableView.reloadData()
            }
        }
    }
    
    private func reloadData() {
        viewModel.reloadData { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - Search
extension EventsListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        eventManager.getEvents()
       }
    
    
    private func setupSearchController() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Event"
        searchController.searchBar.autocapitalizationType = .allCharacters
        navigationItem.searchController = searchController
    }
}
