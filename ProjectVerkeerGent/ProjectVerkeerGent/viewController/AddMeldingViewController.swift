import UIKit
import CoreLocation
import RealmSwift
class AddMeldingViewController: UITableViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var type: UITextField!
    @IBOutlet weak var voertuig: UITextField!
    @IBOutlet weak var mededeling: UITextField!
    
    var nieuweMelding: Melding?
    let meldingVoorDB = MeldingObject()
    
    override func viewDidLoad() {
        
        saveButton.isEnabled = false
        type.delegate = self
        
    }
    //save wordt opgeroepen zoals in popover-oefening, maar hier wordt de data gepersisteerd mbv Realm
    @IBAction func save() {
        let typeMelding = type.text!
        let voertuigMelding = voertuig.text!
        let mededelingMelding = mededeling.text!
        let location = CLLocationCoordinate2D()
        let vandaag = Date()
        nieuweMelding = Melding(type: typeMelding, transport: voertuigMelding, message: mededelingMelding, location: location)
        
        
        meldingVoorDB.type = typeMelding
        meldingVoorDB.transport = voertuigMelding
        meldingVoorDB.message = mededelingMelding
        meldingVoorDB.datum = vandaag.toString()
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(meldingVoorDB)
            print("LOG: \(meldingVoorDB.message)")
        }
        
        //de segue UnwindFromToegevoegd wordt hier opgeroepen om de popover te sluiten als er op "add" gedrukt wordt
        performSegue(withIdentifier: "toegevoegd", sender: self)
    }


}
//extensie om de save button niet beschikbaar te zetten als er niets getypt wordt
extension AddMeldingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            saveButton.isEnabled = newText.characters.count > 0
        }else {
            saveButton.isEnabled = string.characters.count > 0
        }
        
        
        return true
    }
}

