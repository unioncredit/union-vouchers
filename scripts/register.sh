# Register
# registeres voucher as union member

allowanceCalldata=$(seth calldata "allowance(address,address)(uint256)" $ETH_FROM $USER_MANAGER_ADDRESS);
allowance=$(seth call $UNION_ADDRESS $allowanceCalldata | seth --to-dec);

if [[ $allowance -eq 0 ]]
then
  echo "[*] allowance is 0 approving..."
  seth send $UNION_ADDRESS "approve(address,uint256)" $USER_MANAGER_ADDRESS $MAX_UINT256;
else
  echo "[*] allowance is $allowance";
fi

echo "[*] register as union member";
seth --gas-price=10000000000 send $USER_MANAGER_ADDRESS "registerMember(address)" $VOUCHER_ADDRESS;

