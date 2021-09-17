vouchCallData=$(seth calldata "updateTrust(address,uint256)" $1 $2);

echo "[*] vouching for $1";

seth --gas-price=10000000000 send $VOUCHER_ADDRESS "call(address,bytes)" $USER_MANAGER_ADDRESS $vouchCallData;
