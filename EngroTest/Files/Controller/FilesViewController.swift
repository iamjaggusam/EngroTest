//
//  FilesViewController.swift
//  EngroTest
//
//  Created by JaGgu Sam on 06/12/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class FilesViewController: UIViewController {
    
    @IBOutlet weak var filesTableView: UITableView!
    var files = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // Setup Views
    func setupViews() {
        self.filesTableView.dataSource = self
        self.filesTableView.delegate = self
        self.filesTableView.dragDelegate = self
        self.filesTableView.dragInteractionEnabled = true
        self.filesTableView.register(UINib(nibName: "FilesTableViewCell", bundle: nil), forCellReuseIdentifier: "FilesTableViewCell")
        self.filesTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        self.filesTableView.separatorColor = self.filesTableView.backgroundColor
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onClickAddFile(_ sender: Any) {
        openFiles()
    }
    
    // Open Files App to pick documents
    func openFiles() {
        var documentPicker: UIDocumentPickerViewController!
        
        let supportedTypes: [UTType] = [.item]
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true)
    }
}

// MARK: - Handling picked document url and filename
extension FilesViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        for url in urls {
            
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                return
            }
            
            do {
                let name = url.lastPathComponent
                let fileData: [String: Any] = ["name": name,
                                           "url": url]
                files.append(fileData)
                let data = try Data.init(contentsOf: url)
                print(data)
            }
            catch {
                print(error.localizedDescription)
            }
            
            // Make sure you release the security-scoped resource when you finish.
            do { url.stopAccessingSecurityScopedResource() }
        }
        
        self.filesTableView.reloadData()
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView Delegates, DataSource and Drag and Drop functionality
extension FilesViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if files.count == 0 {
            self.filesTableView.setEmptyView(title: "No files added", message: "")
        } else {
            self.filesTableView.restore()
        }
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilesTableViewCell", for: indexPath) as! FilesTableViewCell
        cell.loadData(data: files[indexPath.row])
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.white
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = files[indexPath.row]
        return [ dragItem ]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = files.remove(at: sourceIndexPath.row)
        files.insert(mover, at: destinationIndexPath.row)
    }
}
