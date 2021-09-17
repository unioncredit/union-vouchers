allowanceCalldata=$(seth calldata "allowance(address,address)(uint256)" $VOUCHER_ADDRESS $USER_MANAGER_ADDRESS);
allowance=$(seth call $UNION_ADDRESS $allowanceCalldata | seth --to-dec);

if [[ $allowance -eq 0 ]]
then
  echo "[*] allowance is 0 approving..."
  approvalCalldata=$(seth calldata "approve(address,uint256)" $USER_MANAGER_ADDRESS $MAX_UINT256);
  ## send this approval to multicall
  seth send $VOUCHER_ADDRESS "call(address,bytes)" $UNION_ADDRESS $approvalCalldata;
else
  echo "[*] allowance is $allowance";
fi

echo "[*] register as union member";
registerCallData=$(seth calldata "registerMember(address)" $VOUCHER_ADDRESS);

seth --gas-price=10000000000 send $VOUCHER_ADDRESS "call(address,bytes)" $USER_MANAGER_ADDRESS $registerCallData;

