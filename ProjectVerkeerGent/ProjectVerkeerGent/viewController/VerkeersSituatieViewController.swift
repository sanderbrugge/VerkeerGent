import UIKit
import MapKit

class VerkeersSituatieViewController: UITableViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var melding: UILabel!
    @IBOutlet weak var mededeling: UILabel!
    @IBOutlet weak var transport: UILabel!
    @IBOutlet weak var geenConnectie: UIView!
    private var meldingen: [Melding] = []
    
    
    
    override func viewDidLoad() {
        tableView.addSubview(geenConnectie)
        geenConnectie.translatesAutoresizingMaskIntoConstraints = false
        tableView.addConstraints([
            //nieuwe manier
            geenConnectie.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            geenConnectie.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        geenConnectie.isHidden = true
        
        
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
        let locatieGent: CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.073825, 3.734788)
        
        let region: MKCoordinateRegion = MKCoordinateRegionMake(locatieGent, span)
        
        mapView.setRegion(region, animated: true)
        
        
    
        
       
        
        
        VerkeerSituatie.shared.getMeldingen() {
            (melding: [Melding]?) in
            
            self.meldingen = melding!
            
            print("LOG: aantal meldingen= \(melding!.count)")
            self.tableView.reloadData()
            
        }
        
    /*  if meldingen.count > 0 {
            for i in 0...meldingen.count - 1 {
                let coordinate: CLLocationCoordinate2D = meldingen[i].location
                maakAnnotatie(met: coordinate)
                melding.text = "type: \(meldingen[i].type)"
                mededeling.text = "mededeling: \(meldingen[i].message)"
                transport.text = "voertuig: \(meldingen[i].transport)"
                
            }

        }
        */
       
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    private func maakAnnotatie(met coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = coordinate
        annotation.title = "test anno"
        mapView.addAnnotation(annotation)
    }
    
    private func showErrorView() {
        self.geenConnectie.isHidden = false
        tableView.separatorStyle = .none
    }
    private func hideErrorView() {
        self.geenConnectie.isHidden = true
        tableView.separatorStyle = .singleLine
    }
    func refreshTableView() {
        self.tableView.reloadData()
        let aantal = meldingen.count
        if aantal > 0 {
            self.hideErrorView()
        }
        print("LOG: is refreshing")
        self.tableView.refreshControl!.endRefreshing()
    }
    
    //hardcoded data door problemen met mapview in alamofire, code staat nog in commentaar
    private func initData(){
        
    }

}

