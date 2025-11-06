// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BatchStorage.sol";

contract StatusEvents is BatchStorage {
    event BatchCreated(uint256 indexed batchId, string drugName);
    event StatusUpdated(uint256 indexed batchId, BatchStatus status, string message);
    event SupplierAdded(uint256 indexed supplierId, address addr, string name);
    event LabAdded(uint256 indexed labId, address addr, string name);
    event WholesalerAdded(uint256 indexed wholesalerId, address addr, string name);
    event PharmacyAdded(uint256 indexed pharmacyId, address addr, string name);

    // Public view helper to convert status to a string for UIs (simple mapping)
    function getBatchStatus(uint256 _batchID) public view returns (string memory) {
        require(_batchID > 0 && _batchID <= batchCtr, "Invalid batch ID");
        BatchStatus s = DrugBatches[_batchID].status;
        if (s == BatchStatus.Pending) return "Batch Order Pending";
        if (s == BatchStatus.IngredientsSourced) return "Ingredients Sourced Stage";
        if (s == BatchStatus.Production) return "Production Stage";
        if (s == BatchStatus.InTransit) return "Distribution Stage (In Transit)";
        if (s == BatchStatus.AtPharmacy) return "Stocked at Pharmacy";
        if (s == BatchStatus.Dispensed) return "Dispensed to Patient";
        return "Unknown";
    }
}
