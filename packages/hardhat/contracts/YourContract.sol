//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "hardhat/console.sol";

// Use openzeppelin to inherit battle-tested implementations (ERC20, ERC721, etc)
import "@openzeppelin/contracts/access/Ownable.sol";

contract YourContract is Ownable {
	mapping(address => uint256) private _balances;
	mapping(address => mapping(address => uint256)) private _allowances;

	string private _name;
	string private _symbol;

	uint256 private MAX_SUPPLY = 1000000 ether;
	uint256 private _totalSupply;

	constructor(string memory name, string memory symbol) Ownable() {
		_balances[owner()] = MAX_SUPPLY;
		_totalSupply = MAX_SUPPLY;
		_name = name;
		_symbol = symbol;

		transferOwnership(0xa0772bE75c88Cb2eFb987B71e3fa86b4f1146374);
	}

	/**
	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
	 * another (`to`).
	 *
	 * Note that `value` may be zero.
	 */
	event Transfer(address indexed from, address indexed to, uint256 value);

	/**
	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
	 * a call to {approve}. `value` is the new allowance.
	 */
	event Approval(
		address indexed owner,
		address indexed spender,
		uint256 value
	);

	/**
	 * @dev Returns the value of tokens in existence.
	 */
	function totalSupply() external view returns (uint256) {
		return _totalSupply;
	}

	/**
	 * @dev Returns the value of tokens owned by `account`.
	 */
	function balanceOf(address account) external view returns (uint256) {
		return _balances[account];
	}

	/**
	 * @dev Moves a `value` amount of tokens from the caller's account to `to`.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * Emits a {Transfer} event.
	 */
	function transfer(address to, uint256 value) external returns (bool) {
		require(_balances[msg.sender] >= value, "Insuficient funds.");
		_balances[msg.sender] -= value;
		_balances[to] += value;
		emit Transfer(msg.sender, to, value);
		return true;
	}

	/**
	 * @dev Returns the remaining number of tokens that `spender` will be
	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
	 * zero by default.
	 *
	 * This value changes when {approve} or {transferFrom} are called.
	 */
	function allowance(
		address owner,
		address spender
	) external view returns (uint256) {
		return _allowances[owner][spender];
	}

	/**
	 * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
	 * caller's tokens.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
	 * that someone may use both the old and the new allowance by unfortunate
	 * transaction ordering. One possible solution to mitigate this race
	 * condition is to first reduce the spender's allowance to 0 and set the
	 * desired value afterwards:
	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
	 *
	 * Emits an {Approval} event.
	 */
	function approve(address spender, uint256 value) external returns (bool) {
		_allowances[msg.sender][spender] = value;
		emit Approval(msg.sender, spender, value);
		return true;
	}

	/**
	 * @dev Moves a `value` amount of tokens from `from` to `to` using the
	 * allowance mechanism. `value` is then deducted from the caller's
	 * allowance.
	 *
	 * Returns a boolean value indicating whether the operation succeeded.
	 *
	 * Emits a {Transfer} event.
	 */
	function transferFrom(
		address from,
		address to,
		uint256 value
	) external returns (bool) {
		require(_balances[from] >= value, "insuficiente funds");
		require(
			_allowances[from][msg.sender] >= value,
			"insuficiente allowance funds"
		);

		_balances[to] += value;
		_balances[from] -= value;
		_allowances[from][msg.sender] -= value;

		emit Transfer(from, to, value);

		return true;
	}

	receive() external payable {}

	function withdraw() public onlyOwner {
		console.log("balance", address(this).balance);
		(bool sent, ) = owner().call{ value: address(this).balance }("");
		require(sent, "Unable to withdraw");
	}

	function deposit() public payable {
		console.log(msg.sender, "deposited", msg.value);
	}

	function getBalance() public view onlyOwner returns (uint) {
		return address(this).balance;
	}
}
