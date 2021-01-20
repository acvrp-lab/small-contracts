pragma solidity ^0.6.0;
//SPDX-License-Identifier: UNLICENSED

abstract contract Rescuable {
    
    address constant etherAddr = address(0);
    
    function _checkRescuer() internal virtual;
    // i use a virtual func instead of transfer(), as this is not limited for ERC20 or other standard tokens
    function _rescueToken(address token, address to, uint256 value) internal virtual;
    function extraBalanceOf(address) public virtual returns (uint256);
    
    modifier onlyRescuer {
        _checkRescuer();
        _;
    }
    
    function rescueToken(address token, address to, uint256 value) public onlyRescuer {
        if (value <= extraBalanceOf(token)) {
            _rescueToken(token, to, value);
        }
    }
    
    function rescueToken(address token, address to) public onlyRescuer {
        _rescueToken(token, to, extraBalanceOf(token));
    }
    
    function rescueEther(address payable to, uint256 value) public onlyRescuer {
        if (value <= extraBalanceOf(etherAddr)) {
            to.transfer(value);
        }
    }
    
    function rescueEther(address payable to) public onlyRescuer {
        to.transfer(extraBalanceOf(etherAddr));
    }
}
