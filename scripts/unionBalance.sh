CALLDATA=$(seth calldata "balanceOf(address)(unit256)" $1);
seth call $UNION_ADDRESS $CALLDATA | seth --to-dec

