stakedAmount=$(seth call $USER_MANAGER_ADDRESS "getStakerBalance(address)(uint256)" $VOUCHER_ADDRESS);

if [[ $stakedAmount -eq 0 ]]
then 
  echo "[*] no value staked";
  exit;
else
  echo "[*] staked amount: $stakedAmount";
fi


lockedAmount=$(seth call $USER_MANAGER_ADDRESS "getTotalLockedStake(address)(uint256)" $VOUCHER_ADDRESS);

echo "[*] locked amount: $lockedAmount";

withdrawable=$(echo "$stakedAmount - $lockedAmount" | bc);

echo "[*] withdrawable amount: $withdrawable";

unStake() {
  calldata=$(seth calldata "unstake(uint256)" $withdrawable);
  seth send $VOUCHER_ADDRESS "call(address,bytes)" $USER_MANAGER_ADDRESS $calldata;
}

while true; do
    read -p "Do you wish to continue? (y/N) " yn
    case $yn in
      [Yy]* ) unStake; break;;
      [Nn]* ) exit;;
      * ) exit;;
    esac
done
