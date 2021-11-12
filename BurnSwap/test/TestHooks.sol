pragma solidity >= 0.5.0 >0.9.0;

import "./BurnToken.sol";
import "../truffle/Assert.sol";

contract TestHooks {
    bool paused;

    function beforeEach() public {
        paused = false;
    }

    function testPausedOff() public {
        Assert.equal(paused,false,"Paused has to be off");
    }
}