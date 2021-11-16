pragma solidity >= 0.5.0 < 0.9.0;

// For using from oracle 
import "./AggregatorV3Interface.sol";
import "./BurnToken.sol";
import "./BurnTokenFactory.sol";



contract BurnSwap {

    // For solving inteeger vulnerable
    // using SafeMath for uint256;

    // State variables:
    address payable public burning;
    // address payable public BurnAddress = payable(address(0x000000000000000000000000000000000000dEaD));
    address payable public User;

    //Set Swap contract address:
    address public swapAddress;

    // Swap balance; (determined via BurnToken's constructor)
    uint256 public SwapBalance;

    // Create an instance of BurnToken
    BurnToken public token;

    //Create an instance of BurnTokenFactory:
    BurnTokenFactory public factory;

    // Determine Ethereum Price:
    AggregatorV3Interface internal EthereumPrice;







    // Set mapping received:
    // for swapping mission
    mapping(address => bool) received;
    mapping(address => uint256) receivedAmount;
    
    // a mpping for fallback() function:
    mapping(address => uint256) wrongReceives;



    constructor() payable {
        burning = payable(0x000000000000000000000000000000000000dEaD);

        EthereumPrice = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

        swapAddress = address(this);    
    }



    //Set modifier: 
    modifier OnlyUser(address _user){
        require(token.isUser(_user) == true);
            _;
    }

    // modifier OnlyAdmins(address _admin) {
    //     require(token.isAdmin(_admin) == true);
    //         _;
    // }
    
    modifier OnlySwap(address _swap) {
        require(swapAddress == _swap);
            _;
    }



    // Set events:
    // User can buy BURN just via Ethereum (afterwards ETH will burn)
    event BuyBurn(address _swap, address _spender, uint256 _amount);
    // and then BURN token will send to wallet
    event Burn(uint256 _amoumt);
    // When contract receive Ether for swapping:
    event receiveEther(uint256 _amount);





   function setBalance(uint256 _amount) public OnlySwap(msg.sender) returns(bool) {
        SwapBalance = _amount;
    }


    function Buy(address payable _to, uint256 _amount) public OnlyUser(msg.sender) returns(bool){
        require(_to != address(0x0) && msg.sender.balance >= _amount);
        require(token.pauseStatus() == false);

        bool sent = token.Sending(_to, _amount);
        require(sent == true);

        // determine who sent ether to our contract
        User = payable(msg.sender);
        
        emit BuyBurn(swapAddress, msg.sender, _amount);
        return true;
    }
    
        // bool success = BurnTokenFactory.createBurnWallet();
        // require(success == true);

    function Swap(address _from, uint256 _amount) public OnlySwap(msg.sender) returns(bool) {
        require(received[User] == true && token.pauseStatus() == false,"User didn't send Ethereum yet");
        uint256 amount = receivedAmount[User];
        
        bool sent = User.send(amount);
        
        require(sent == true);
        return true;
    }



    receive() external payable {
        received[msg.sender] = true;
        receivedAmount[msg.sender] = msg.value;
        
        emit receiveEther(msg.value);

        // Burning Ethereum received:
        bool sent = burning.send(msg.value);
        emit Burn(msg.value);
    }

    fallback() external payable {
        receivedAmount[msg.sender];
    }

}
