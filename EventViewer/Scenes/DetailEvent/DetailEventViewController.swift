//
//  DetailEvent.swift
//  EventViewer
//
//  Created by Иван Тарасенко on 17.04.2023.
//

import UIKit

final class DetailEventViewController: UITableViewController {
    
    // MARK: - Outlets
    private lazy var deleteButtonItem = UIBarButtonItem(
        title: "Delete",
        style: .plain,
        target: self,
        action: #selector(DetailEventViewController.deleteEvent)
    )
    
    private lazy var cancelButtonItem = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: self,
        action: #selector(DetailEventViewController.cancelEvent)
    )
    
    // MARK: - Variables
    var indexCell = 0
    var eventManager: EventManager!
    
    private let dataSource: DetailEventDataSource
    private let delegate: DetailEventDelegate
    private var viewModel: DetailEventModelProtocol!
    
    // MARK: - LifeCycle
    init(dataSource: DetailEventDataSource, delegate: DetailEventDelegate) {
        self.dataSource = dataSource
        self.delegate = delegate
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventManager.capture(.detailScreen("DETAIL_OF_EVENT"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailEventViewModel(eventManager: eventManager, indexCell: indexCell)
        configerUI()
        bing()
    }
    
    // MARK: - Configere
    private func configerUI() {
        navigationItem.leftBarButtonItem = self.deleteButtonItem
        navigationItem.rightBarButtonItem = self.cancelButtonItem
        navigationItem.title = "Event Details"
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    private func bing() {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        dataSource.viewModel = viewModel
    }
    
    // MARK: - Actions
    @objc
    private func deleteEvent() {
        eventManager.deleteEvent(index: indexCell)
        dismiss(animated: true)
    }
    
    @objc
    private func cancelEvent() {
        dismiss(animated: true)
    }
}
