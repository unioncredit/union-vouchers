balance=$(seth call $DAI_ADDRESS "balanceOf(address)(uint256)" $VOUCHER_ADDRESS);
echo "send $balance to $ETH_FROM";
callData=$(seth calldata "transfer(address,uint256)(bool)" $ETH_FROM $balance);
seth send $VOUCHER_ADDRESS "call(address,bytes)" $DAI_ADDRESS $callData;
