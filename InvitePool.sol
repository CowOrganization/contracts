// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    function mint(address account, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(
            value
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(
            value,
            "SafeERC20: decreased allowance below zero"
        );
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        bytes memory returndata = address(token).functionCall(
            data,
            "SafeERC20: low-level call failed"
        );
        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

library EnumerableSet {
    struct Set {
        bytes32[] _values;
        mapping(bytes32 => uint256) _indexes;
    }

    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastvalue = set._values[lastIndex];

                set._values[toDeleteIndex] = lastvalue;
                set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
            }

            set._values.pop();

            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    function _contains(Set storage set, bytes32 value)
        private
        view
        returns (bool)
    {
        return set._indexes[value] != 0;
    }

    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    function _at(Set storage set, uint256 index)
        private
        view
        returns (bytes32)
    {
        return set._values[index];
    }

    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    function add(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    function remove(AddressSet storage set, address value)
        internal
        returns (bool)
    {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    function contains(AddressSet storage set, address value)
        internal
        view
        returns (bool)
    {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    function at(AddressSet storage set, uint256 index)
        internal
        view
        returns (address)
    {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    function values(AddressSet storage set)
        internal
        view
        returns (address[] memory)
    {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        assembly {
            result := store
        }

        return result;
    }
}

interface IInvitePool {
    function inviteUser(
        address invite,
        address inviter,
        uint256 _amount,
        uint inviteType
    ) external payable returns (bool);

    function getCurrentRate() external view returns (uint256);

    function recieveForToken(
        uint256 amount,
        address reward,
        uint256 rewardsBlocks
    ) external payable returns (bool);
}

interface IStakingHelper {
    function stake( uint _amount, address _recipient, address _inviter ) external;
}

contract InvitePool is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Address for address;
    using EnumerableSet for EnumerableSet.AddressSet;

    mapping(address => address) _inviteInviter;
    mapping(address => EnumerableSet.AddressSet) _inviterInvite;
    mapping(address => uint256) _invitePower;
    mapping(address => uint256) _inviteTime;
    
    uint256 private currentPower = 0;
    mapping(address => uint256) _inviterPower;
    mapping (address => bool) public intvitedUsers;

    struct RewardParams {
        mapping(address => uint256) _inviteArrears;
        mapping(address => uint256) _inviteArrearsLessZero;
        mapping(address => uint256) _alreadyReward;
        uint256 rewardPerNew;
        uint256 rewardCompensate;
    }
    RewardParams[3] rewardParams;
    mapping(address => uint256) _cowRewardRate;
    // cow;  0
    // busd; 1
    // usdt; 2
    // BNB: 3
    address[3] private _contracts;
    uint256[3] private _contractsBalance;
    mapping(address => uint256) _rewarded24Hour;

    // revice token rate
    uint256 private _rate = 3000;

    //cow rate
    uint256 _cowRate = 112;
    // EnumerableSet.AddressSet private _callers;
    address public fund;
    address public stakingHelper;
    address public inviteRouter;
    bool public useHelper;
    // one day only withdraw once
    uint256 _rewardedCycle = 86400;
    // 30 days invite will be invalid
    uint256 _inviteExpiredTime = 2592000;

    event InvitePower(address inviter, address invite, uint256 power);

    constructor() {
        useHelper = false;
    }

    function initialize(
        address cow_,
        address busd_,
        address usdt_,
        uint256 rate_
    ) public onlyOwner {
        _contracts[0] = cow_;
        _contracts[1] = busd_;
        _contracts[2] = usdt_;
        _rate = rate_;
    }

    function withdraw(address token, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(msg.sender, amount);
    }

    function invitePower()
        external
        view
        returns (uint256 power, uint256 myPower)
    {
        return (currentPower, _inviterPower[msg.sender]);
    }

    function getInviter(address invite)
        external
        view
        returns (address inviter)
    {
        return _inviteInviter[invite];
    }

    function _isAddNewInvite(address invite, address inviter)
        internal
        returns (bool)
    {
        if(intvitedUsers[invite]){
            return false;
        }
        intvitedUsers[invite] = true;
        return inviter != address(0x0);
    }

    function _isAddPower(address invite) internal view returns (bool) {
        return (_inviteInviter[invite] != address(0x0) &&
            _inviteTime[invite] > block.timestamp);
    }

    // // onlyCaller .div(1e18)
    function inviteUser(
        address invite,
        address inviter,
        uint256 amount,
        uint inviteType
    ) external onlyRouter returns (bool) {
        require(invite != address(0x0), "invite is null");

        uint256 _amount = inviteType == 2 || inviteType == 7?amount.div(1e9):amount.div(1e18);
        if (_isAddNewInvite(invite, inviter)) {
            _inviteInviter[invite] = inviter;
            EnumerableSet.add(_inviterInvite[inviter], invite);
            // add invite expired time
            _addExpired30DaysInvite(invite);
        }

        if (_isRemoveExpired30DaysInvite(invite)) {
            _removeExpired30DaysInvite(invite);
            return true;
        }

        if (_isAddPower(invite)) {
            uint256 power;
            if (inviteType == 1 && _amount >= 30) {
                // purchase  add operate
                power = _amount.mul(5);
                _addPower(inviter, power, invite);
                _updatePower(inviter, power);
            }
            if (inviteType == 2 && _amount >= 8) {
                // stake add operate  cow
                power = _amount;
                _addPower(inviter, power, invite);
                _updatePower(inviter, power);
            }
            if (inviteType == 7 && _amount >= 8) {
                // unstake sub opoperater  cow
                power = _amount.mul(1e9);
                _subPower(inviter, power, invite);
                _updatePowerLessZero(inviter, power);
            }
            if (inviteType == 3 && _amount >= 100) {
                // Bond  add operate
                power = _amount.mul(2);
                _addPower(inviter, power, invite);
                _updatePower(inviter, power);
            }
            if (inviteType == 4 && _amount >= 100) {
                // NFT Blind box  add operate
                power = _amount.mul(3);
                _addPower(inviter, power, invite);
                _updatePower(inviter, power);
            }
            if (inviteType == 5 && _amount >= 100) {
                // NFT  add operate
                power = _amount;
                _addPower(inviter, power, invite);
                _updatePower(inviter, power);
            }
            if (inviteType == 6) {
                // building  add operate
                power = _amount.mul(3);
                _addPower(inviter, power, invite);
                _updatePower(inviter, power);
            }

            emit InvitePower(inviter, invite, power);
        }
        return true;
    }

    function _addPower(
        address inviter,
        uint256 power,
        address invite
    ) internal {
        _inviterPower[inviter] = _inviterPower[inviter].add(power);
        _invitePower[invite] = _invitePower[invite].add(power);
        currentPower = currentPower.add(power);
    }

    function _subPower(
        address inviter,
        uint256 power,
        address invite
    ) internal {
        _inviterPower[inviter] = _inviterPower[inviter].sub(power);
        _invitePower[invite] = _invitePower[invite].sub(power);
        currentPower = currentPower.sub(power);
    }

    function _updatePowerLessZero(address inviter, uint256 power) internal {
        for (uint8 i = 0; i < rewardParams.length; i++) {
            uint256 myRewardCompensate = power
                .mul(rewardParams[i].rewardPerNew)
                .div(10000);
            rewardParams[i]._inviteArrearsLessZero[inviter] = rewardParams[i]
                ._inviteArrearsLessZero[inviter]
                .add(myRewardCompensate);
            uint256 balance = _contractsBalance[i];
            rewardParams[i].rewardPerNew = balance
                .add(rewardParams[i].rewardCompensate)
                .mul(10000)
                .div(currentPower);
        }
    }

    function _updatePower(address inviter, uint256 power) internal {
        for (uint8 i = 0; i < rewardParams.length; i++) {
            // rewardPerNew
            uint256 myRewardCompensate = power
                .mul(rewardParams[i].rewardPerNew)
                .div(10000);
            rewardParams[i]._inviteArrears[inviter] = rewardParams[i]
                ._inviteArrears[inviter]
                .add(myRewardCompensate);
            rewardParams[i].rewardCompensate = rewardParams[i]
                .rewardCompensate
                .add(myRewardCompensate);
            uint256 balance = _contractsBalance[i];
            rewardParams[i].rewardPerNew = balance
                .add(rewardParams[i].rewardCompensate)
                .mul(10000)
                .div(currentPower);
        }
    }

    function recieveForToken(
        uint256 amount,
        address reward,
        uint256 
    ) external onlyFund returns (bool) {
        require(isContract(reward), "error contract address");
        for (uint8 i = 0; i < _contracts.length; i++) {
            if (_contracts[i] == reward) {
                IERC20(reward).safeTransferFrom(msg.sender, address(this), amount);
                _contractsBalance[i] = _contractsBalance[i].add(amount);
                _verifyPower();
            }
        }
        return true;
    }

    function userStateInPool(address,uint) external pure returns (bool) {
        return true;
    }

    function updateUserInPool(address,bool,uint) external view {
    }

    function isContract(address reward) internal view returns (bool) {
        for (uint256 i = 0; i < _contracts.length; i++) {
            if (_contracts[i] == reward) {
                return true;
            }
        }
        return false;
    }

    function _verifyPower() internal {
        for (uint8 i = 0; i < rewardParams.length; i++) {
            uint256 balance = _contractsBalance[i];
            uint256 rewardPerNew = balance
                .add(rewardParams[i].rewardCompensate)
                .mul(10000)
                .div(currentPower);
            if (rewardPerNew != rewardParams[i].rewardPerNew) {
                rewardParams[i].rewardPerNew = rewardPerNew;
            }
        }
    }

    function _computeReward(uint8 index, address inviter)
        internal
        view
        returns (uint256)
    {
        return
            rewardParams[index]
                .rewardPerNew
                .mul(_inviterPower[inviter])
                .div(10000)
                .add(rewardParams[index]._inviteArrearsLessZero[inviter])
                .sub(rewardParams[index]._inviteArrears[inviter])
                .sub(rewardParams[index]._alreadyReward[inviter]);
    }

    function _computeRewardWithCow(uint8 i, address inviter)
        internal
        view
        returns (uint256)
    {
        uint256 reward = _computeReward(i, inviter);
        return reward.mul(_cowRate).div(10000);
    }

    function _transferReward(
        uint8 index,
        address inviter,
        uint256 reward
    ) internal returns (bool) {
        if(index == 0 && useHelper){
            IERC20( _contracts[index] ).approve( stakingHelper, reward );
            IStakingHelper( stakingHelper ).stake( reward, inviter ,address(0));
        }else{
            IERC20(_contracts[index]).safeTransfer(inviter, reward);
            rewardParams[index]._alreadyReward[inviter] = rewardParams[index]
                                                        ._alreadyReward[inviter].add(reward);
        }
        
        return true;
    }

    function harvestInviteReward() external returns (bool) {
        // require(EnumerableSet.length(_inviterInvite[msg.sender]) > 0, "you havent invite user.");
        
        if (_isRemoveExpired30DaysInvite(msg.sender)) {
            _removeExpired30DaysInvite(msg.sender);
        }
        require(
            _rewarded24Hour[msg.sender] < block.timestamp,
            "you have already withdraw today!"
        );

        for (uint8 i = 0; i < 3; i++) {
            uint256 reward;
            // require(reward > 0, "you havent enough amount to harvest!");
            if (i == 0) {
                reward = _computeRewardWithCow(i, msg.sender);
            } else {
                reward = _computeReward(i, msg.sender);
            }
            if(reward > 0){
                // transfer reward to inviter
                _transferReward(i, msg.sender, reward);
            }
        }
        
        // add: one day only withdraw one times
        _rewarded24Hour[msg.sender] = block.timestamp.add(_rewardedCycle);
        return true;
    }

    function setRewardedCycle(uint256 cycle)
        external
        onlyOwner
        returns (bool)
    {
        _rewardedCycle = cycle;
        return true;
    }

    function setInviteExpiredTime(uint256 expired)
        external
        onlyOwner
        returns (bool)
    {
        _inviteExpiredTime = expired;
        return true;
    }

    function _addExpired30DaysInvite(address invite) internal {
        // 30days
        _inviteTime[invite] = block.timestamp.add(_inviteExpiredTime);
    }

    function _isRemoveExpired30DaysInvite(address invite)
        internal
        view
        returns (bool)
    {
        // 30days
        return (_invitePower[invite] > 0 &&
            _inviteTime[invite] < block.timestamp);
    }

    // internal
    function _removeExpired30DaysInvite(address invite) internal {
        // 30days
        address inviter = _inviteInviter[invite];
        uint256 power = _invitePower[invite];
        _subPower(inviter, power, invite);
        _updatePowerLessZero(inviter, power);
    }

    function getInvitePower(address invite) external view returns (uint256) {
        return _invitePower[invite];
    }

    function inviteTime(address invite) external view returns (uint256) {
        return _inviteTime[invite];
    }

    function myAllReward() external view returns (uint256[6] memory) {
        
        uint256[6] memory _myReward;
        if(EnumerableSet.length(_inviterInvite[msg.sender]) == 0){
            _myReward[0] = currentPower;
            return _myReward;
        }

        _myReward[0] = currentPower;
        _myReward[1] = _inviterPower[msg.sender];
        
        for (uint8 i = 0; i < _contracts.length; i++) {
            _myReward[i + 2] = _computeReward(i, msg.sender);
        }
        // one day only withdraw one times
        if (_rewarded24Hour[msg.sender] < block.timestamp){
            _myReward[5] = _computeRewardWithCow(0, msg.sender);
        }
        return _myReward;
    }

    function getRewardParams(uint8 i)
        external view
        returns (
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256
        )
    {
        
        uint256 a = rewardParams[i].rewardPerNew;
        uint256 b = _inviterPower[msg.sender];
        uint256 c = rewardParams[i]._inviteArrears[msg.sender];
        uint256 d = rewardParams[i]._inviteArrearsLessZero[msg.sender];
        uint256 e = rewardParams[i]._alreadyReward[msg.sender];
        uint256 f = _computeReward(i, msg.sender);
        uint256 g = 0;
        if (i == 0) g = _computeRewardWithCow(0, msg.sender);
        return (a, b, c, d, e, f, g);
    }

    function getContractsBalance() external view returns (uint256[3] memory) {
        return _contractsBalance;
    }

    function setContractsBalance(uint256 i, uint256 amount)
        external
        onlyOwner
    {
        _contractsBalance[i] = _contractsBalance[i].add(amount);
    }

    function getCurrentRate() external view returns (uint256) {
        if(currentPower == 0) return 0;
        return _rate;
    }

    function setCurrentRate(uint256 rate) external onlyOwner returns (bool) {
        _rate = rate;
        return true;
    }

    function getCowRate() external view returns (uint256) {
        return _cowRate;
    }

    function setCowRate(uint256 rate) external onlyOwner returns (bool) {
        _cowRate = rate;
        return true;
    }

    function getInviteLength(address inviter) public view returns (uint256) {
        return EnumerableSet.length(_inviterInvite[inviter]);
    }

    function getInvite(address inviter, uint256 _index)
        external
        view
        returns (address)
    {
        require(
            _index < getInviteLength(inviter),
            "Token: index out of bounds"
        );
        return EnumerableSet.at(_inviterInvite[inviter], _index);
    }

    function getInvites(address inviter)
        external
        view
        returns (address[] memory)
    {
        return EnumerableSet.values(_inviterInvite[inviter]);
    }

    function setContract(address cont_, uint256 i) public onlyOwner {
        _contracts[i] = cont_;
    }

    function getContracts() public view returns (address[3] memory) {
        return _contracts;
    }

    function setFund(address _fund) public onlyOwner returns (bool) {
        require(_fund != address(0),"InvitePool: fund address is zero");
        fund = _fund;
        return true;
    }

    function setStakingHeler(address _stakingHelper) public  onlyOwner returns (bool){
        if(_stakingHelper == address(0)){
            useHelper = false;
        }else{
            useHelper = true;
        }
        stakingHelper = _stakingHelper;
        return true;
    }

    modifier onlyFund() {
        require(msg.sender == fund, "InvitePool: not the fund");
        _;
    }

    function setInviteRouter(address _router) public onlyOwner returns (bool) {
        require(_router != address(0),"InvitePool: fund address is zero");
        inviteRouter = _router;
        return true;
    }
    
    modifier onlyRouter() {
        require(inviteRouter == msg.sender, "InvitePool: not the Router");
        _;
    }
}
