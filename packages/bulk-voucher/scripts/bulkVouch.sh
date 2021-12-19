echo "[*] vouching pending";
ETH_GAS=30000000 seth --gas-price=10000000000 send $VOUCHER_ADDRESS $1;
echo "[*] vouching complete";
