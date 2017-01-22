import UIKit
import RealmSwift

class MeldingDetailViewController: UITableViewController {
    @IBOutlet weak var vandaag: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var mededeling: UILabel!
    @IBOutlet weak var transport: UILabel!
    
    let realm = try! Realm()
    let meldingDetail = self
    var melding: MeldingObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        vandaag.text = melding.datum
        type.text = "Melding: \(melding.type)"
        mededeling.text = "Mededeling: \(melding.message)"
        transport.text = "Voertuig: \(melding.transport)"
    }
    
    @IBAction func verwijderMelding(sender: UIButton) {
        let alertController = UIAlertController(title: "Verwijder", message: "Wenst u deze melding te verwijderen?", preferredStyle: .alert)
        let verwijder = UIAlertAction(title: "Ja", style: .default, handler: {(alert: UIAlertAction!) in
            self.performSegue(withIdentifier: "verwijderd", sender: self.meldingDetail)
            
        })
        //nil = doe niets voor deze actie, aka "cancel"
        let behoud = UIAlertAction(title: "Nee", style: .default, handler: nil)
        alertController.addAction(verwijder)
        alertController.addAction(behoud)
        
        self.present(alertController, animated: true, completion: nil)
        
    }

}
