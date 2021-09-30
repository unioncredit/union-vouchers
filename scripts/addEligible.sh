addEligible() {
  echo $1;
  calldata=$(seth calldata "addEligible(address[])" "[$1]");
  ETH_GAS=3000000 seth send $VOUCHER_ADDRESS $calldata;
}

if [[ -z "$ETH_PASSWORD" ]]
then 
  echo "[*] set ETH_PASSWORD";
  exit;
fi

export -f addEligible;

chunkSize=2;

cat $1 | xargs -n $chunkSize | sed 's/ /,/g' | xargs -n1 -I {} bash -c 'addEligible "{}"'
