//
//  DetailViewController.swift
//  ElongationPreview
//
//  Created by Abdurahim Jauzee on 14/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class DetailViewController: ElongationDetailViewController {

    var dataSource: CityWalkWaypoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        let gridViewCellNib = UINib(nibName: GridViewCell.nibName, bundle: nil)
        tableView.register(gridViewCellNib, forCellReuseIdentifier: GridViewCell.reuseIdentifier)
//        tableView.registerNib(GridViewCell.self)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeue(GridViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: GridViewCell.reuseIdentifier) as! GridViewCell
        cell.dataSource = dataSource
        cell.configureCell()
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        let appearance = ElongationConfig.shared
        let headerHeight = appearance.topViewHeight + appearance.bottomViewHeight
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight - headerHeight
    }
}
