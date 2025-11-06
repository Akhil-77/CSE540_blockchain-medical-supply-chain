// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BatchStorage.sol";
import "./HelperUtils.sol";
import "./StatusEvents.sol";

contract BatchLifecycle is BatchStorage, HelperUtils, StatusEvents {
    // Create a new drug batch (only Owner)
    function createDrugBatch(string memory _drugName, string memory _batchDescription) public onlyByOwner {
        require((supplierCtr > 0) && (labCtr > 0) && (wholesalerCtr > 0) && (pharmacyCtr > 0), "All participant roles must be registered first");
        batchCtr++;
        DrugBatches[batchCtr] = DrugBatch(batchCtr, _drugName, _batchDescription, 0, 0, 0, 0, BatchStatus.Pending);
        emit BatchCreated(batchCtr, _drugName);
        emit StatusUpdated(batchCtr, BatchStatus.Pending, "Batch created and pending");
    }

    // Supplier calls this to source ingredients for a batch
    function sourceIngredients(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr, "Invalid batch ID");
        uint256 _id = findSupplier(msg.sender);
        require(_id > 0, "Sender not registered as supplier");
        require(DrugBatches[_batchID].status == BatchStatus.Pending, "Batch not in Pending state");

        DrugBatches[_batchID].supplierId = _id;
        DrugBatches[_batchID].status = BatchStatus.IngredientsSourced;
        emit StatusUpdated(_batchID, BatchStatus.IngredientsSourced, "Ingredients sourced by supplier");
    }

    // Lab calls this to mark production
    function produceBatch(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr, "Invalid batch ID");
        uint256 _id = findLab(msg.sender);
        require(_id > 0, "Sender not registered as lab");
        require(DrugBatches[_batchID].status == BatchStatus.IngredientsSourced, "Batch not ready for production");

        DrugBatches[_batchID].labId = _id;
        DrugBatches[_batchID].status = BatchStatus.Production;
        emit StatusUpdated(_batchID, BatchStatus.Production, "Production completed by lab");
    }

    // Wholesaler marks batch as shipped (in transit)
    function shipToWholesaler(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr, "Invalid batch ID");
        uint256 _id = findWholesaler(msg.sender);
        require(_id > 0, "Sender not registered as wholesaler");
        require(DrugBatches[_batchID].status == BatchStatus.Production, "Batch not in Production state");

        DrugBatches[_batchID].wholesalerId = _id;
        DrugBatches[_batchID].status = BatchStatus.InTransit;
        emit StatusUpdated(_batchID, BatchStatus.InTransit, "Shipped to wholesaler (in transit)");
    }

    // Pharmacy receives the batch from wholesaler
    function shipToPharmacy(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr, "Invalid batch ID");
        uint256 _id = findPharmacy(msg.sender);
        require(_id > 0, "Sender not registered as pharmacy");
        require(DrugBatches[_batchID].status == BatchStatus.InTransit, "Batch not in transit");

        DrugBatches[_batchID].pharmacyId = _id;
        DrugBatches[_batchID].status = BatchStatus.AtPharmacy;
        emit StatusUpdated(_batchID, BatchStatus.AtPharmacy, "Batch stocked at pharmacy");
    }

    // Pharmacy dispenses to patient
    function dispenseToPatient(uint256 _batchID) public {
        require(_batchID > 0 && _batchID <= batchCtr, "Invalid batch ID");
        uint256 _id = findPharmacy(msg.sender);
        require(_id > 0, "Sender not registered as pharmacy");
        require(_id == DrugBatches[_batchID].pharmacyId, "Only assigned pharmacy can dispense");
        require(DrugBatches[_batchID].status == BatchStatus.AtPharmacy, "Batch not at pharmacy");

        DrugBatches[_batchID].status = BatchStatus.Dispensed;
        emit StatusUpdated(_batchID, BatchStatus.Dispensed, "Dispensed to patient");
    }
}
