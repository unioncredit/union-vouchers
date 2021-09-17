CALLDATA=$(seth calldata "checkIsMember(address)(bool)" $VOUCHER_ADDRESS);
RESP=$(seth call $USER_MANAGER_ADDRESS $CALLDATA | seth --to-dec);

if [ $RESP -eq 1 ] ; then echo "true"; else echo "false"; fi

