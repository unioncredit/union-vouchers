CALLDATA=$(seth calldata "balanceOf(address)(unit256)" $VOUCHER_ADDRESS);
seth call $UNION_ADDRESS $CALLDATA | seth --to-dec

