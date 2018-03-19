pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/SigLibrary/ECVerify.sol";

contract Test_ECVerify {
    function test_v0() {
        ECVerify test = ECVerify(DeployedAddresses.ECVerify());
        bytes32 hash = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad;
        bytes memory sig = "\xac\xa7\xda\x99\x7a\xd1\x77\xf0\x40\x24\x0c\xdc\xcf\x69\x05\xb7\x1a\xb1\x6b\x74\x43\x43\x88\xc3\xa7\x2f\x34\xfd\x25\xd6\x43\x93\x46\xb2\xba\xc2\x74\xff\x29\xb4\x8b\x3e\xa6\xe2\xd0\x4c\x13\x36\xea\xce\xaf\xda\x3c\x53\xab\x48\x3f\xc3\xff\x12\xfa\xc3\xeb\xf2\x00";
       bool expected = true;
        Assert.equal(test.ecverify(hash, sig, 0x0e5cb767cce09a7f3ca594df118aa519be5e2b5a), expected,true);
    }

    function test_v1() {
        ECVerify test = ECVerify(DeployedAddresses.ECVerify());
        bytes32 hash = 0x47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad;
        bool expected = true;
        bytes memory sig = "\xde\xba\xaa\x0c\xdd\xb3\x21\xb2\xdc\xaa\xf8\x46\xd3\x96\x05\xde\x7b\x97\xe7\x7b\xa6\x10\x65\x87\x85\x5b\x91\x06\xcb\x10\x42\x15\x61\xa2\x2d\x94\xfa\x8b\x8a\x68\x7f\xf9\xc9\x11\xc8\x44\xd1\xc0\x16\xd1\xa6\x85\xa9\x16\x68\x58\xf9\xc7\xc1\xbc\x85\x12\x8a\xca\x01";
        Assert.equal( test.ecverify(hash, sig, 0x8743523d96a1b2cbe0c6909653a56da18ed484af), expected,true);
    }
}