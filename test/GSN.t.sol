// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Gsn.sol";
import "../src/WhitelistPaymaster.sol";
import "../src/Forwarder.sol";

contract TestGsn is Test {
    // NoGasTran public Gsntest;
    // GatewayForwarder public Forwarder;
    // WhitelistPaymaster public Paymaster;

    address Attacker = address(0x8894E0a0c962CB723c1976a4421c95949bE2D4E3);

    function setUp() public {
        vm.prank(Attacker);
        Paymaster = new WhitelistPaymaster();
        Forwarder = new GatewayForwarder();
        Gsntest = new NoGasTran(address(Forwarder));
    }

    function testcaptureTheFlag() public {
        Gsntest.captureTheFlag();
    }

}
