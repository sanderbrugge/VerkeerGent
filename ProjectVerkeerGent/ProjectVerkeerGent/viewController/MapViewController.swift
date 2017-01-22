import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    private var meldingen = [Melding]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       getData()

        
        
    }
    private func maakAnnotatie(met melding: Melding) -> MKPointAnnotation{
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = melding.location
        annotation.title = melding.type
        annotation.subtitle = melding.transport
        
        return annotation
    }
    @IBAction func refreshTableViewMetKnop() {
        print("LOG: op refresh geklikt")
        getData()
    }
 
    private func getData(){
        VerkeerSituatie.shared.getMeldingen() {
            (melding: [Melding]?) in
            guard melding!.count > 0 else {
                print("LOG: geen meldingen")
                return
            }
            
            
            self.meldingen = melding!
            print("LOG: aantal meldingen= \(melding!.count)")
            
            let span: MKCoordinateSpan = MKCoordinateSpanMake(0.2, 0.2)
            let locatieGent: CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.073825, 3.734788)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(locatieGent, span)
            
            self.mapView.setRegion(region, animated: true)
            
            
            for i in 0...melding!.count - 1 {
                print("LOG: \(self.meldingen[i].location)")
                let annotation = self.maakAnnotatie(met: self.meldingen[i])
                
                
                self.mapView.addAnnotation(annotation)
                
            }
            
        }

    }

    //init functie voor als er geen meldingen in de json zitten, voor mee te testen
    /*private func initMeldingen(){
         let locatieGent: CLLocationCoordinate2D = CLLocationCoordinate2DMake(51.073825, 3.734788)
        let melding1 = Melding(type: "Ongeluk", transport: "Auto", message: "er is een ongeval gebeurt op de E40", location: locatieGent)
        let melding2 = Melding(type: "Vertraging", transport: "trein", message: "vertraging van 10 min tussen Gent en Brussel", location: locatieGent)
        let melding3 = Melding(type: "Opletten", transport: "Auto", message: "Sluikstort op de weg, R4 ter hoogte van evergem", location: locatieGent)
        let melding4 = Melding(type: "Glad", transport: "Alle", message: "Er is nog niet gestrooid!", location: locatieGent)
        
    }*/
}


















