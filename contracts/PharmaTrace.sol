// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PharmaTrace {
    // Smart Contract owner will be the person who deploys the contract
    // only he can authorize various roles.
    address public Owner;

    // This constructor is called when the smart contract is deployed.
    constructor() public {
        Owner = msg.sender;
    }

    // Roles (flow of pharma supply chain)
    // IngredientSupplier;
    // This is where Labs get raw materials to make medicines
    // PharmaceuticalLab;
    // Various WHO guidelines should be followed by this entity
    // Wholesaler;
    // This entity distributes the drug batches to pharmacies
    // Pharmacy;
    // Normal customer buys from the pharmacy

    // Modifier to make sure only the owner is using the function
    modifier onlyByOwner() {
        require(msg.sender == Owner);
        _;
    }

    // Stages of a drug batch in the pharma supply chain
    enum BatchStatus {
        Pending,
        IngredientsSourced,
        Production,
        InTransit,
        AtPharmacy,
        Dispensed
    }
    // We use this to track every single drug batch

    // Drug Batch count
    uint256 public batchCtr = 0;
    // Ingredient Supplier count
    uint256 public supplierCtr = 0;
    // Pharmaceutical Lab count
    uint256 public labCtr = 0;
    // Wholesaler count
    uint256 public wholesalerCtr = 0;
    // Pharmacy count
    uint256 public pharmacyCtr = 0;

    // To store information about the drug batch
    struct DrugBatch {
        uint256 batchId; // unique batch id
        string drugName; // name of the drug
        string batchDescription; // about this batch
        uint256 supplierId; // id of the Ingredient Supplier for this batch
        uint256 labId; // id of the Lab for this batch
        uint256 wholesalerId; // id of the Wholesaler for this batch
        uint256 pharmacyId; // id of the Pharmacy for this batch
        BatchStatus status; // current batch status
    }

    // To store all the drug batches on the blockchain
    mapping(uint256 => DrugBatch) public DrugBatches;

    // To show status to client applications
    function getBatchStatus(
        uint256 _batchID
    ) public view returns (string memory) {
        require(batchCtr > 0);
        if (DrugBatches[_batchID].status == BatchStatus.Pending)
            return "Batch Order Pending";
        else if (DrugBatches[_batchID].status == BatchStatus.IngredientsSourced)
            return "Ingredients Sourced Stage";
        else if (DrugBatches[_batchID].status == BatchStatus.Production)
            return "Production Stage";
        else if (DrugBatches[_batchID].status == BatchStatus.InTransit)
            return "Distribution Stage (In Transit)";
        else if (DrugBatches[_batchID].status == BatchStatus.AtPharmacy)
            return "Stocked at Pharmacy";
        else if (DrugBatches[_batchID].status == BatchStatus.Dispensed)
            return "Dispensed to Patient";
    }

    // To store information about ingredient supplier
    struct IngredientSupplier {
        address addr;
        uint256 id; // supplier id
        string name; // Name of the ingredient supplier
        string place; // Place the supplier is based in
    }

    // To store all the ingredient suppliers on the blockchain
    mapping(uint256 => IngredientSupplier) public Suppliers;

    // To store information about pharmaceutical lab
    struct PharmaceuticalLab {
        address addr;
        uint256 id; // lab id
        string name; // Name of the lab
        string place; // Place the lab is based in
    }

    // To store all the labs on the blockchain
    mapping(uint256 => PharmaceuticalLab) public Labs;

    // To store information about wholesaler
    struct Wholesaler {
        address addr;
        uint256 id; // wholesaler id
        string name; // Name of the wholesaler
        string place; // Place the wholesaler is based in
    }

    // To store all the wholesalers on the blockchain
    mapping(uint256 => Wholesaler) public Wholesalers;

    // To store information about pharmacy
    struct Pharmacy {
        address addr;
        uint256 id; // pharmacy id
        string name; // Name of the pharmacy
        string place; // Place the pharmacy is based in
    }

    // To store all the pharmacies on the blockchain
    mapping(uint256 => Pharmacy) public Pharmacies;

    // To add ingredient suppliers. Only contract owner can add a new one.
    function addIngredientSupplier(
        address _address,
        string memory _name,
        string memory _place
    ) public onlyByOwner {
        supplierCtr++;
        Suppliers[supplierCtr] = IngredientSupplier(_address, supplierCtr, _name, _place);
    }

    // To add a pharmaceutical lab. Only contract owner can add a new one.
    function addPharmaceuticalLab(
        address _address,
        string memory _name,
        string memory _place
    ) public onlyByOwner {
        labCtr++;
        Labs[labCtr] = PharmaceuticalLab(_address, labCtr, _name, _place);
    }

    // To add a wholesaler. Only contract owner can add a new one.
    function addWholesaler(
        address _address,
        string memory _name,
        string memory _place
    ) public onlyByOwner {
        wholesalerCtr++;
        Wholesalers[wholesalerCtr] = Wholesaler(_address, wholesalerCtr, _name, _place);
    }

    // To add a pharmacy. Only contract owner can add a new one.
    function addPharmacy(
        address _address,
        string memory _name,
        string memory _place
    ) public onlyByOwner {
        pharmacyCtr++;
        Pharmacies[pharmacyCtr] = Pharmacy(_address, pharmacyCtr, _name, _place);
    }

    // To supply ingredients from supplier to the lab
    function sourceIngredients(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr);
        uint256 _id = findSupplier(msg.sender);
        require(_id > 0);
        require(DrugBatches[_batchID].status == BatchStatus.Pending);
        DrugBatches[_batchID].supplierId = _id;
        DrugBatches[_batchID].status = BatchStatus.IngredientsSourced;
    }

    // To check if Supplier is available in the blockchain
    function findSupplier(address _address) private view returns (uint256) {
        require(supplierCtr > 0);
        for (uint256 i = 1; i <= supplierCtr; i++) {
            if (Suppliers[i].addr == _address) return Suppliers[i].id;
        }
        return 0;
    }

    // To produce the drug batch
    function produceBatch(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr);
        uint256 _id = findLab(msg.sender);
        require(_id > 0);
        require(DrugBatches[_batchID].status == BatchStatus.IngredientsSourced);
        DrugBatches[_batchID].labId = _id;
        DrugBatches[_batchID].status = BatchStatus.Production;
    }

    // To check if Lab is available in the blockchain
    function findLab(address _address) private view returns (uint256) {
        require(labCtr > 0);
        for (uint256 i = 1; i <= labCtr; i++) {
            if (Labs[i].addr == _address) return Labs[i].id;
        }
        return 0;
    }

    // To ship batches from Lab to Wholesaler
    function shipToWholesaler(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr);
        uint256 _id = findWholesaler(msg.sender);
        require(_id > 0);
        require(DrugBatches[_batchID].status == BatchStatus.Production);
        DrugBatches[_batchID].wholesalerId = _id;
        DrugBatches[_batchID].status = BatchStatus.InTransit;
    }

    // To check if Wholesaler is available in the blockchain
    function findWholesaler(address _address) private view returns (uint256) {
        require(wholesalerCtr > 0);
        for (uint256 i = 1; i <= wholesalerCtr; i++) {
            if (Wholesalers[i].addr == _address) return Wholesalers[i].id;
        }
        return 0;
    }

    // To ship batches from Wholesaler to Pharmacy
    function shipToPharmacy(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr);
        uint256 _id = findPharmacy(msg.sender);
        require(_id > 0);
        require(DrugBatches[_batchID].status == BatchStatus.InTransit);
        DrugBatches[_batchID].pharmacyId = _id;
        DrugBatches[_batchID].status = BatchStatus.AtPharmacy;
    }

    // To check if Pharmacy is available in the blockchain
    function findPharmacy(address _address) private view returns (uint256) {
        require(pharmacyCtr > 0);
        for (uint256 i = 1; i <= pharmacyCtr; i++) {
            if (Pharmacies[i].addr == _address) return Pharmacies[i].id;
        }
        return 0;
    }

    // To sell medicines from pharmacy to consumer
    function dispenseToPatient(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr);
        uint256 _id = findPharmacy(msg.sender);
        require(_id > 0);
        require(_id == DrugBatches[_batchID].pharmacyId); // Only the correct pharmacy can mark as dispensed
        require(DrugBatches[_batchID].status == BatchStatus.AtPharmacy);
        DrugBatches[_batchID].status = BatchStatus.Dispensed;
    }

    // To add new drug batches to the stock
    function createDrugBatch(
        string memory _drugName,
        string memory _batchDescription
    ) public onlyByOwner {
        require((supplierCtr > 0) && (labCtr > 0) && (wholesalerCtr > 0) && (pharmacyCtr > 0));
        batchCtr++;
        DrugBatches[batchCtr] = DrugBatch(
            batchCtr,
            _drugName,
            _batchDescription,
            0,
            0,
            0,
            0,
            BatchStatus.Pending
        );
    }
}