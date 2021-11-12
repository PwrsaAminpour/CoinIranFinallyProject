pragma solidity >= 0.5.0 < 0.9.0;

import "./BurnToken.sol";

//Create BurnToken:
contract BurnTokenFactory {

    // these tokens are for TokenOwner
    BurnToken[] private TokenList;
    address public TokenOwner;
    
    
    

    // Set Token Owner of new Token in constructor
    constructor() payable {
        TokenOwner = msg.sender;
    }
    
    

    // Set event, when a BURN token gonna create:
    event Create(BurnToken burntoken);


        
    modifier OnlyOwner() {
        require(TokenOwner == msg.sender);
            _;
    }    
    

    function CreateBurnWallet() external OnlyOwner returns(address){
        BurnToken burntoken = new BurnToken();

        TokenList.push(burntoken);

        emit Create(burntoken);

        return address(this);
    }
    
    
    function listShow() public view returns(BurnToken[] memory) {
        return TokenList;
    }
}