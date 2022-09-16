//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
pragma experimental ABIEncoderV2;

import "@opengsn/contracts/src/BasePaymaster.sol";

///a sample paymaster that has whitelists for senders and targets.
/// - if at least one sender is whitelisted, then ONLY whitelisted senders are allowed.
/// - if at least one target is whitelisted, then ONLY whitelisted targets are allowed.
contract WhitelistPaymaster is BasePaymaster {
    

    bool public useSenderWhitelist;
    bool public useTargetWhitelist;

    mapping(address => bool) public senderWhitelist;
    mapping(address => bool) public targetWhitelist;

    constructor(address sender, address target, IRelayHub relayhub, address forwarder) {
        senderWhitelist[sender] = true;
         useSenderWhitelist = true;
         targetWhitelist[target] = true;
         useTargetWhitelist = true;
         setRelayHub(relayhub);
         setTrustedForwarder(forwarder);
    }

    function whitelistSender(address sender) public onlyOwner {
        senderWhitelist[sender] = true;
        useSenderWhitelist = true;
    }

    function whitelistTarget(address target) public onlyOwner {
        targetWhitelist[target] = true;
        useTargetWhitelist = true;
    }

    function versionPaymaster()
        external
        view
        virtual
        override
        returns (string memory)
    {
        return "2.2.0+opengsn.test-pea.ipaymaster";
    }

    event Received(uint256 eth);

    receive() external payable override {
        emit Received(msg.value);
    }

    event Withdrawed(uint256 eth);

      function withdrawAmount() public onlyOwner {
        address payable localowner = payable(_msgSender());
        localowner.transfer(address(this).balance);
        emit Withdrawed(address(this).balance);
    }

    event SampleRecipientPostCall(bool success, uint actualCharge);

    function preRelayedCall(
        GsnTypes.RelayRequest calldata relayRequest,
        bytes calldata signature,
        bytes calldata approvalData,
        uint256 maxPossibleGas
    )
        external
        virtual
        override
        returns (bytes memory context, bool revertOnRecipientRevert)
    {
        (relayRequest, signature, approvalData, maxPossibleGas);
        require(approvalData.length == 0, "approvalData: invalid length");
        require(relayRequest.relayData.paymasterData.length == 0, "paymasterData: invalid length");

        _verifyForwarder(relayRequest);

        if (useSenderWhitelist) {
            require(
                senderWhitelist[relayRequest.request.from],
                "sender not whitelisted"
            );
        }
        if (useTargetWhitelist) {
            require(
                targetWhitelist[relayRequest.request.to],
                "target not whitelisted"
            );
        }
         
        return ("",false);
    }

    function postRelayedCall(
        bytes calldata context,
        bool success,
        uint256 gasUseWithoutPost,
        GsnTypes.RelayData calldata relayData
    ) external virtual override {
        (context, success, gasUseWithoutPost, relayData);
         emit SampleRecipientPostCall(success, gasUseWithoutPost);
    }
}
