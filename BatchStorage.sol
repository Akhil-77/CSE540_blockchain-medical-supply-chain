// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./AccessControl.sol";

contract BatchStorage is AccessControl {
    // Stages of a drug batch
    enum BatchStatus {
        Pending,
        IngredientsSourced,
        Production,
        InTransit,
        AtPharmacy,
        Dispensed
    }

    struct DrugBatch {
        uint256 batchId;
        string drugName;
        string batchDescription;
        uint256 supplierId;
        uint256 labId;
        uint256 wholesalerId;
        uint256 pharmacyId;
        BatchStatus status;
    }

    uint256 public batchCtr = 0;
    mapping(uint256 => DrugBatch) public DrugBatches;
}
