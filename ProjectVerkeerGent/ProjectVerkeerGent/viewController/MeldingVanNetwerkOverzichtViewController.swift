import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation
import MapKit

class MeldingVanNetwerkOverzichtViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var geenMeldingen: UIView!
    
    fileprivate var meldingen = [Melding]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(geenMeldingen)
        geenMeldingen.translatesAutoresizingMaskIntoConstraints = false
        tableView.addConstraints([
            //nieuwe manier
            geenMeldingen.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            geenMeldingen.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        geenMeldingen.isHidden = true
      
        VerkeerSituatie.shared.getMeldingen() {
            (melding: [Melding]?) in
           
            guard melding!.count > 0 else {
                self.showErrorView()
                return
            }
            
            
            self.meldingen = melding!
            
            print("LOG: aantal meldingen= \(melding!.count)")
            self.tableView.reloadData()
            self.titel.text = "Er zijn \(melding!.count) meldingen."
        }
        
        
        titel.text = "Er zijn \(meldingen.count) meldingen."
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
    }
    @IBAction func refreshTableViewMetKnop() {
        refreshTableView()
    }
    public func refreshTableView() {
        self.tableView.reloadData()
        
        VerkeerSituatie.shared.getMeldingen() {
            (melding: [Melding]?) in
            
            self.meldingen = melding!
            
            print("LOG: aantal meldingen= \(melding!.count)")
            self.tableView.reloadData()
            self.titel.text = "Er zijn \(melding!.count) meldingen."
        }

        
        print("LOG: is refreshing")
        self.tableView.refreshControl!.endRefreshing()
    }
    private func showErrorView() {
        self.geenMeldingen.isHidden = false
        tableView.separatorStyle = .none
    }
    private func hideErrorView() {
        self.geenMeldingen.isHidden = true
        tableView.separatorStyle = .singleLine
    }
    @IBAction func unwindFromMap(_ segue: UIStoryboardSegue) {
            refreshTableView()
    }
    

    
    
}

extension MeldingVanNetwerkOverzichtViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meldingen.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeldingCell", for: indexPath) as! MeldingCell
        let type =  meldingen[indexPath.row].type
        let mededeling = meldingen[indexPath.row].message
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let locatieGent: CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.073825, 3.734788)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(locatieGent, span)
        
        cell.mapView.setRegion(region, animated: true)
        cell.mededeling.text = mededeling
        cell.type.text = type
        
        
        return cell
    }
}
