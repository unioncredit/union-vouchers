CALLDATA=$(seth calldata "balanceOf(address)(unit256)" $1);
seth call $DAI_ADDRESS $CALLDATA | seth --to-dec

