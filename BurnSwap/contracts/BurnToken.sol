pragma solidity >= 0.5.0 < 0.9.0;

import "./BurnSwap.sol";
import "./BurnTokenFactory.sol";


contract BurnToken {
    address payable public User;
    address public Admin;

    uint8 decimal = 18;
    uint256 totalSupply = 180 * (10 ** (decimal));

    bool public paused;

    BurnSwap public burnswap;

    BurnTokenFactory public factory;



    constructor() payable {
        Admin = tx.origin;
        paused = false;

        // Give all of tokens to BurnSwap:
        burnswap.setBalance(totalSupply);
    }



    mapping(address => bool) UserApproved;
    mapping(address => bool) Admins;
    mapping(address => uint256) balance;



    event TransferEvent(address indexed _form, address indexed _to, uint256 _amount);
    event TurnOnPaused(address indexed _changer);
    event TurnOffPaused(address indexed _changer);



    modifier UserExistence(address _user) {
        require(UserApproved[_user] == true);
            _;
    }

    modifier OnlyAdmin(address _admin) {
        require(Admins[_admin] == true);
            _;
    }




    // functions:
    function Balance() public view returns(uint256) {
        return balance[msg.sender];
    }

    function total() public view returns(uint256) {
        return totalSupply;
    }

    function Sending(address payable _to, uint256 _amount) public UserExistence(msg.sender) returns(bool) {
        uint256 userBalance = balance[msg.sender];
 
        require(userBalance >= _amount && _to != address(0x0));
        require(paused == false);

        (bool sent, bytes memory data) = _to.call{value: _amount}("");

        require(sent, "The transaction was failed");
        require(balance[msg.sender] < userBalance);

        emit TransferEvent(msg.sender, _to, _amount);
        return true;
    }
    

    function pauseStatus() public view OnlyAdmin(msg.sender) returns(bool) {
        return paused;
    }


    function TurningOnPaused() public OnlyAdmin(msg.sender) returns(bool) {
        require(paused == false);
        paused = true;

        if (paused == true) {
            return true;
        } else {
            assert(paused = false);
            return false;
        }
    }


    function TurningOffPaused() public OnlyAdmin(msg.sender) returns(bool) {
        require(paused == true);
        paused = false;

        if (paused == false) {
            return true;
        } else {
            assert(paused = true);
            return false;
        }
    }


    function addAdmin(address _new) external OnlyAdmin(msg.sender) returns(bool) {
        require(_new != address(0x0) && Admins[_new] == false);
        Admins[_new] = true;

        if (Admins[_new] == true) {
            return true;
        } else {
            assert(Admins[_new] = false);
            return false;
        }
    }

    function isAdmin(address _admin) public view OnlyAdmin(msg.sender) returns(bool) {
        return Admins[_admin];
    }



    function addUser(address _user) public returns(bool) {
        require(_user != address(0x0) && UserApproved[_user] == false);

        address wallet = factory.CreateBurnWallet();
        UserApproved[_user] = true;

        if (UserApproved[wallet] == true) {
            return true;
        } else {
            assert(UserApproved[wallet] = false);
            return false;
        }
    }

    function isUser(address _wallet) public view OnlyAdmin(msg.sender) returns(bool) {
        return UserApproved[_wallet];
    }

}