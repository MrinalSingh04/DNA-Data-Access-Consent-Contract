// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * 🧬 DNA Data Access Consent Contract v25
 *
 * ⚠️ NOTE: This contract NEVER stores raw DNA/genomic data.
 * Instead, it stores only encrypted content references (e.g., IPFS CIDs hashed to bytes32).
 *
 * ------------------------------
 * Key Features:
 * ------------------------------
 * ✅ Subjects (data owners) can register DNA data references.
 * ✅ Subjects grant/revoke access to researchers with time-limited consent.
 * ✅ Researchers must register before requesting access.
 * ✅ Full audit log of all consent changes.
 * ✅ Secure handling: only subject controls their own data.
 */

contract DNAAccessConsent {
    struct DNARecord {
        bytes32 dataHash; // e.g., hash of encrypted DNA blob (IPFS CID → keccak256)
        address owner; // subject who owns the DNA
        bool active; // if DNA record is active
    }

    struct Consent {
        bool granted;
        uint256 expiry; // timestamp until consent is valid
    }

    struct Researcher {
        string name;
        string org;
        bool approved;
    }

    // DNA ID → DNARecord
    mapping(uint256 => DNARecord) public dnaRecords;

    // researcher → registered profile
    mapping(address => Researcher) public researchers;

    // DNA ID → researcher → consent
    mapping(uint256 => mapping(address => Consent)) public consents;

    // Audit log
    event DNARegistered(
        uint256 indexed dnaId,
        address indexed owner,
        bytes32 dataHash
    );
    event ResearcherRegistered(
        address indexed researcher,
        string name,
        string org
    );
    event ConsentGranted(
        uint256 indexed dnaId,
        address indexed researcher,
        uint256 expiry
    );
    event ConsentRevoked(uint256 indexed dnaId, address indexed researcher);

    uint256 public dnaCounter;

    // ------------------------------
    // DNA Subject Functions
    // ------------------------------

    /// Register new DNA record
    function registerDNA(bytes32 _dataHash) external returns (uint256) {
        dnaCounter++;
        dnaRecords[dnaCounter] = DNARecord({
            dataHash: _dataHash,
            owner: msg.sender,
            active: true
        });

        emit DNARegistered(dnaCounter, msg.sender, _dataHash);
        return dnaCounter;
    }

    /// Grant researcher access with expiry
    function grantConsent(
        uint256 _dnaId,
        address _researcher,
        uint256 _duration
    ) external {
        DNARecord storage record = dnaRecords[_dnaId];
        require(record.owner == msg.sender, "Not data owner");
        require(record.active, "DNA inactive");
        require(researchers[_researcher].approved, "Researcher not registered");

        consents[_dnaId][_researcher] = Consent({
            granted: true,
            expiry: block.timestamp + _duration
        });

        emit ConsentGranted(_dnaId, _researcher, block.timestamp + _duration);
    }

    /// Revoke consent manually
    function revokeConsent(uint256 _dnaId, address _researcher) external {
        DNARecord storage record = dnaRecords[_dnaId];
        require(record.owner == msg.sender, "Not data owner");

        consents[_dnaId][_researcher].granted = false;
        consents[_dnaId][_researcher].expiry = 0;

        emit ConsentRevoked(_dnaId, _researcher);
    }

    // ------------------------------
    // Researcher Functions
    // ------------------------------

    /// Researcher self-registration
    function registerResearcher(
        string memory _name,
        string memory _org
    ) external {
        researchers[msg.sender] = Researcher({
            name: _name,
            org: _org,
            approved: true
        });

        emit ResearcherRegistered(msg.sender, _name, _org);
    }

    // ------------------------------
    // Public View Functions
    // ------------------------------

    /// Check if researcher has valid access
    function hasAccess(
        uint256 _dnaId,
        address _researcher
    ) public view returns (bool) {
        Consent memory c = consents[_dnaId][_researcher];
        return c.granted && block.timestamp <= c.expiry;
    }
}
