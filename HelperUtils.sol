// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./BatchStorage.sol";

contract HelperUtils is BatchStorage {
    // Finder helpers return the ID for a given address, or 0 if not found
    function findSupplier(address _address) internal view returns (uint256) {
        if (supplierCtr == 0) return 0;
        for (uint256 i = 1; i <= supplierCtr; i++) {
            if (Suppliers[i].addr == _address) return Suppliers[i].id;
        }
        return 0;
    }

    function findLab(address _address) internal view returns (uint256) {
        if (labCtr == 0) return 0;
        for (uint256 i = 1; i <= labCtr; i++) {
            if (Labs[i].addr == _address) return Labs[i].id;
        }
        return 0;
    }

    function findWholesaler(address _address) internal view returns (uint256) {
        if (wholesalerCtr == 0) return 0;
        for (uint256 i = 1; i <= wholesalerCtr; i++) {
            if (Wholesalers[i].addr == _address) return Wholesalers[i].id;
        }
        return 0;
    }

    function findPharmacy(address _address) internal view returns (uint256) {
        if (pharmacyCtr == 0) return 0;
        for (uint256 i = 1; i <= pharmacyCtr; i++) {
            if (Pharmacies[i].addr == _address) return Pharmacies[i].id;
        }
        return 0;
    }
}
