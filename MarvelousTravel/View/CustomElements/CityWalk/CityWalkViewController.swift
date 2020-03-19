//
//  ViewController.swift
//  ElongationPreviewDemo
//
//  Created by Abdurahim Jauzee on 08/02/2017.
//  Copyright © 2017 Ramotion. All rights reserved.
//

import ElongationPreview
import UIKit

final class CityWalkViewController: ElongationViewController {

    var viewModel: CityWalkViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.generateCityWalk(completionHandler: {
            result in
            if result {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
        setup()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func openDetailView(for indexPath: IndexPath) {
        let id = String(describing: DetailViewController.self)
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: id) as? DetailViewController else { return }
        detailViewController.dataSource = viewModel?.cityWalkWayPoints[indexPath.row]
        expand(viewController: detailViewController)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // TODO rework
        super.scrollViewDidScroll(scrollView)
        if scrollView.contentOffset.y < -200 , let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
}

private extension CityWalkViewController {

    func setup() {
        var config = ElongationConfig()
        config.scaleViewScaleFactor = 0.9
        config.topViewHeight = 190
        config.bottomViewHeight = 170
        config.bottomViewOffset = 20
        config.parallaxFactor = 100
        config.separatorHeight = 0.5
        config.separatorColor = UIColor.white

        // Durations for presenting/dismissing detail screen
        config.detailPresentingDuration = 0.4
        config.detailDismissingDuration = 0.4

        // Customize behaviour
        config.headerTouchAction = .collpaseOnBoth

        // Save created appearance object as default
        ElongationConfig.shared = config
        
        tableView.backgroundColor = UIColor.black
        let elongationCellNib = UINib(nibName: DemoElongationCell.nibName, bundle: nil)
        tableView.register(elongationCellNib, forCellReuseIdentifier: DemoElongationCell.reuseIdentifier)
    }
}

extension CityWalkViewController {

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel!.cityWalkWayPoints.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoElongationCell.reuseIdentifier)
        return cell!
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        super.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
        guard let cell = cell as? DemoElongationCell else { return }
        
        cell.dataSource = viewModel?.cityWalkWayPoints[indexPath.row]
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.configureCell()
    }
}
