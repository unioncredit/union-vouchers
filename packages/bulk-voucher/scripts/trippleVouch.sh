voucher1=0xc4449084c28a3D32bc4be31F02a03e23Fd391250
voucher2=0x61c2E4426D7E138E2993bbA914928385274aF0E3

vouchCallData=$(seth calldata "updateTrust(address,uint256)" $1 $2);

seth --gas-price=10000000000 send $voucher1 "call(address,bytes)" $USER_MANAGER_ADDRESS $vouchCallData;
seth --gas-price=10000000000 send $voucher2 "call(address,bytes)" $USER_MANAGER_ADDRESS $vouchCallData;
