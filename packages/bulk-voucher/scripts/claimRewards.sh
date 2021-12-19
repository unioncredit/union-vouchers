calculateRewardsCallData=$(seth calldata "calculateRewards(address,address)(uint256)" $VOUCHER_ADDRESS $DAI_ADDRESS);
rewards=$(seth call $COMPTROLLER_ADDRESS $calculateRewardsCallData | seth --to-dec);

echo "[*] rewards $rewards";

claimRewards() {
  echo "claiming...";
  withdrawRewardsCallData=$(seth calldata "withdrawRewards()");
  seth --gas-price=10000000000 send $VOUCHER_ADDRESS "call(address,bytes)" $USER_MANAGER_ADDRESS $withdrawRewardsCallData;
}

while true; do
    read -p "Do you wish to claim rewards? (y/N) " yn
    case $yn in
      [Yy]* ) claimRewards; break;;
      [Nn]* ) exit;;
      * ) exit;;
    esac
done

