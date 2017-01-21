import UIKit
import MapKit

class VerkeersSituatieViewController: UITableViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var melding: UILabel!
    @IBOutlet weak var mededeling: UILabel!
    @IBOutlet weak var transport: UILabel!
    private var meldingen: [Melding] = []
    
    
    override func viewDidLoad() {
        VerkeerSituatie.shared.getMeldingen() {
            //nog optionele uitpakking, nog aanpassen naar controlestructuur
            (melding: [Melding]?) in
            //guard deze unwrap
            print("LOG: aantal meldingen= \(melding!.count)")
            for i in 0...melding!.count - 1 {
            self.mapView.region = MKCoordinateRegion(center: melding![i].location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            let pin = MKPointAnnotation()
            pin.coordinate = melding![i].location
            self.mapView.addAnnotation(pin)
                
                self.melding.text = melding![i].type
                self.transport.text = melding![i].transport
            
                self.mededeling.text = melding![i].message
            }
            self.meldingen = melding!
        }
    }
}

