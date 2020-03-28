//
//  ProfileViewController.swift
//  MarvelousTravel
//
//  Created by  Ilia Goncharenko on 2020-03-24.
//  Copyright © 2020 Dmytro Salenko. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var kTableHeaderHeight:CGFloat = 400.0
    @IBOutlet weak var stretchyTableView: UITableView!
    
    var headerView: UIView!
    var pictureView : UIImageView?
    var profilePictureView : UIImageView?
    var fullNameLabel : UILabel?
    var settingButton : UIButton?
    
    var regularPicture : UIImage?
    var user : User?
    
    let userService = UserService(config: URLSessionConfiguration.default)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateHeaderView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        getPictures()
        
        stretchyTableView.dataSource = self
        stretchyTableView.delegate = self
        // Do any additional setup after loading the view.
        stretchyTableView.rowHeight = UITableView.automaticDimension
        stretchyTableView.estimatedRowHeight = 500
        stretchyTableView.separatorStyle = .none
        
        headerView = stretchyTableView.tableHeaderView
        stretchyTableView.tableHeaderView = nil
        stretchyTableView.addSubview(headerView)
        stretchyTableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 0, right: 0)
        stretchyTableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        updateHeaderView()
        
//        createFullnameLabel()
//        createSettingsButton()
    }
    
    func getUser() {
        userService.getSingleUser(userId: "5e7d6092f3e1b2843f7b702d") { (user, error) in
            if user != nil {
                self.user = user
            }
        }
    }
    
    func getPictures() {
            self.userService.getRegularPicture(userId: "5e7d6092f3e1b2843f7b702d") { (image, error) in
                if image != nil {
                    self.regularPicture = image
                    DispatchQueue.main.async {
                        self.createMainPicture()
                        self.createProfilePicture()
                        self.createFullnameLabel()
                        self.createSettingsButton()
                    }
                }
        }
    }
    
    func createMainPicture() {
        if pictureView == nil {
                self.pictureView = UIImageView(frame: CGRect.zero)
        }
        // let picture = UIImage(named: "swift")
        let picture = self.regularPicture
        // filter
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(CIImage(image: picture!), forKey: kCIInputImageKey)
        sepiaFilter?.setValue(0.9, forKey: kCIInputIntensityKey)
        pictureView!.image = UIImage(ciImage: (sepiaFilter?.outputImage!)!)
        self.headerView.addSubview(pictureView!)
        pictureView!.translatesAutoresizingMaskIntoConstraints = false
        pictureView!.contentMode = .scaleToFill
        NSLayoutConstraint.activate([
            pictureView!.topAnchor.constraint(equalTo: self.headerView.topAnchor), pictureView!.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor), self.view.trailingAnchor.constraint(equalTo: pictureView!.trailingAnchor), pictureView!.heightAnchor.constraint(equalTo: self.headerView.heightAnchor, multiplier: 0.70)
        ])
    }
    
    func createProfilePicture() {
        guard let pictureView = pictureView else {return}
        
        if profilePictureView == nil {
            profilePictureView = UIImageView(frame: CGRect.zero)
        }
        self.headerView.addSubview(profilePictureView!)
        profilePictureView?.translatesAutoresizingMaskIntoConstraints = false
        // profilePictureView?.image = UIImage(named: "swift")
        profilePictureView?.image = self.regularPicture
        profilePictureView?.layer.cornerRadius = 55.0
        profilePictureView?.clipsToBounds = true
        profilePictureView?.layer.borderWidth = 4.0
        profilePictureView?.layer.borderColor = UIColor.white.cgColor
        
        profilePictureView?.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            (profilePictureView?.centerXAnchor.constraint(equalTo: pictureView.centerXAnchor))!, (profilePictureView?.centerYAnchor.constraint(equalTo: pictureView.bottomAnchor))!, (profilePictureView?.heightAnchor.constraint(equalTo: profilePictureView!.widthAnchor))!, (profilePictureView?.widthAnchor.constraint(equalTo: pictureView.widthAnchor, multiplier: 0.3))!
        ])
    }
    
    func createFullnameLabel() {
        guard let profilePictureView = profilePictureView else {return}
        
        if fullNameLabel == nil {
            fullNameLabel = UILabel(frame: CGRect.zero)
        }
        self.headerView.addSubview(fullNameLabel!)
        fullNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            (fullNameLabel?.topAnchor.constraint(equalTo: profilePictureView.bottomAnchor, constant: 10.0))!, (fullNameLabel?.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 50.0))!, self.headerView.trailingAnchor.constraint(equalTo: fullNameLabel!.trailingAnchor, constant: 50.0)
        ])
        guard let user = user else {return}
        fullNameLabel?.text = "\(user.first_name!) \(user.last_name!)"
        fullNameLabel?.font = fullNameLabel?.font.withSize(20.0)
        fullNameLabel?.textAlignment = .center
    }
    
    func createSettingsButton() {
        if settingButton == nil {
            settingButton = UIButton(frame: CGRect.zero)
        }
        self.headerView.addSubview(settingButton!)
        settingButton?.translatesAutoresizingMaskIntoConstraints = false
        settingButton?.setImage(UIImage(named: "settings"), for: .normal)
        
        NSLayoutConstraint.activate([
            (settingButton?.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 15.0))!, headerView.trailingAnchor.constraint(equalTo: settingButton!.trailingAnchor, constant: 15.0), (settingButton?.heightAnchor.constraint(equalToConstant: 40.0))!, (settingButton?.widthAnchor.constraint(equalToConstant: 40.0))!
        ])
        self.settingButton?.addTarget(self, action: #selector(settingsButtonOnTouch), for: .touchDown)
    }
    
    @objc func settingsButtonOnTouch(sender : UIButton) {
        let settingsTV = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Settings") as! SettingsTableViewController
        settingsTV.currentUser = user!
        self.present(settingsTV, animated: false, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    
    func updateHeaderView() {
        
        var headerRect = CGRect(x: 0, y: -kTableHeaderHeight, width: stretchyTableView.bounds.width, height: kTableHeaderHeight)
        if stretchyTableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = stretchyTableView.contentOffset.y
            headerRect.size.height = -stretchyTableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
   let conversations = ["Be who you are and say what you feel, because those who mind don't matter and those who matter don't mind.", "We must not allow other people’s limited perceptions to define us.", "Wise men speak because they have something to say; fools because they have to say something. If I am not for myself, who is for me? And if I am only for myself, what am I? And if not now, when? If I am not for myself, who is for me? And if I am only for myself, what am I? And if not now, when?", "Two roads diverged in a wood, and I—I took the one less traveled by, And that has made all the difference.", "I haven’t failed. I’ve just found 10,000 ways that won’t work.", "I’ve learned that people will forget what you said, people will forget what you did, but people will never forget how you made them feel.", "This is single line.", "This is single line."]
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StretchyTableViewCell
        cell.commentLabel.text = conversations[indexPath.section]
        cell.indentationLevel = 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
