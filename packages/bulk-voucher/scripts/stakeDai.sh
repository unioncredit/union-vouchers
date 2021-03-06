# Stake DAI
# Stale voucher addresses total balance of DAI into UNION

allowanceCalldata=$(seth calldata "allowance(address,address)(uint256)" $VOUCHER_ADDRESS $USER_MANAGER_ADDRESS);
allowance=$(seth call $DAI_ADDRESS $allowanceCalldata | seth --to-dec);

if [[ $allowance -eq 0 ]]
then
  echo "[*] allowance is 0 approving..."
  approvalCalldata=$(seth calldata "approve(address,uint256)" $USER_MANAGER_ADDRESS $MAX_UINT256);
  # send this approval to multicall
  seth send $VOUCHER_ADDRESS "call(address,bytes)" $DAI_ADDRESS $approvalCalldata;
else
  echo "[*] allowance is $allowance";
fi

daiBalance=$(seth call $DAI_ADDRESS "balanceOf(address)(uint256)" $VOUCHER_ADDRESS);
stakedAmount=$(seth call $USER_MANAGER_ADDRESS "getStakerBalance(address)(uint256)" $VOUCHER_ADDRESS);

echo "[*] dai balance: $daiBalance, staked amount: $stakedAmount";

stakeDai() {
  # Now we can stake our dai
  echo "[*] staking dai :: $daiBalance"
  stakeCallData=$(seth calldata "stake(uint256)" $daiBalance);

  seth send --gas-price $(echo "$(seth gas-price) * 10" | bc) $VOUCHER_ADDRESS "call(address,bytes)" $USER_MANAGER_ADDRESS $stakeCallData;
}

while true; do
    read -p "Do you wish to continue? (y/N) " yn
    case $yn in
      [Yy]* ) stakeDai; break;;
      [Nn]* ) exit;;
      * ) exit;;
    esac
done

