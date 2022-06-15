pragma solidity >=0.5.0 <0.6.0;

import "./ownable.sol";
import "./safemath.sol";

contract Banking is Ownable{
    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    address payable public childAddress;

    mapping(address => mapping(address => uint256)) private _allowances;

    event Approval(address owner, address spender, uint256 amount);

    function assignChild(address payable _childAddress) external onlyOwner{
        childAddress = _childAddress;
    }

    function deposit() external payable onlyOwner{
        
    }

    function withdraw(uint256 _amount) external onlyChild withDrawalLimit(_amount * 10**18){
        address payable to = make_payable(msg.sender);
        _amount = _amount * 10**18;
        to.transfer((_amount - address(this).balance) + address(this).balance );
    }

    function balanceOf(address account) public view returns (uint256) {
        return address(account).balance;
    }

    function approve(address spender, uint _amount) public returns (bool) {
        address owner = owner();
        _approve(owner, spender, _amount * 10**18);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");


        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function getAllowance(address child) external view returns (uint256){
        address _owner = owner();
        return _allowances[_owner][child];
    }

    function make_payable(address x) internal pure returns (address payable) {
        return address(uint160(x));
    }

    modifier onlyChild(){
        require(msg.sender == childAddress, "Only child is allowed to perform this action");
        _;
    }

    modifier withDrawalLimit(uint _amount){
        address _owner = owner();
        address child = msg.sender;
        uint256 limit = _allowances[_owner][child];
        require(_amount <= limit, "Withdrawal is beyond the limit set by owner");
        require(_amount < address(this).balance, "No sufficient balance");
        _;
    }

}
