// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.0;
pragma abicoder v2;

import "@opengsn/contracts/src/forwarder/Forwarder.sol";

contract GatewayForwarder is Forwarder {

     using ECDSA for bytes32;

     Forwarder forwarder = new Forwarder();  

    address public trustedRelayHub;

     constructor(address _trustedRelayHub,string memory _name,string memory _version,string memory _typeName, string memory _typeSuffix) {
        trustedRelayHub = _trustedRelayHub;
        forwarder.registerDomainSeparator(_name, _version);
        forwarder.registerRequestType(_typeName, _typeSuffix);
    }


    function setTrustedRelayHub(address _trustedRelayHub) external {
        trustedRelayHub = _trustedRelayHub;
    }


    function _verifySig(
        ForwardRequest calldata req,
        bytes32 domainSeparator,
        bytes32 requestTypeHash,
        bytes calldata suffixData,
        bytes calldata sig)
    internal
    override
    view
    virtual
    {
        // trustedRelayHub can only be called from a verified Gateway where the signatures are actually checked
        // note that if signature field is set, it will be verified in this Forwarder anyway
        if (msg.sender != trustedRelayHub || sig.length != 0) {

     super._verifySig(req, domainSeparator, requestTypeHash, suffixData, sig);

        }
    }
}
