// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@opengsn/contracts/src/BaseRelayRecipient.sol";

contract NoGasTran is BaseRelayRecipient {

    event FlagCaptured(address previousHolder, address currentHolder);

    address public currentHolder = address(0);
    address public manager;

    constructor(address _trustedForwarder) {
       _setTrustedForwarder(_trustedForwarder);
       manager = msg.sender;
    }

    modifier OnlyManager() {
    require(msg.sender == manager);
    _;
}


 
    function versionRecipient() external view override virtual returns (string memory){
        return "2.2.0";
    }

    function captureTheFlag() external {
        address previousHolder = currentHolder;

        currentHolder = _msgSender();

        emit FlagCaptured(previousHolder, currentHolder);
    }

     function updatesetTrustedForwarder (address _trustedForwarder) external OnlyManager {
       _setTrustedForwarder(_trustedForwarder);
    }
}
