chunkSize=1000

addEligible() {
  echo "[*] adding eligible addresses ($chunkSize)";
  calldata=$(seth calldata "addEligible(address[])" "[$1]");
  seth --gas-price 15000000000 send $VOUCHER_ADDRESS $calldata;
}

if [[ -z "$ETH_PASSWORD" ]]
then 
  echo "[*] set ETH_PASSWORD";
  exit;
fi

input=$(cat $1 | xargs -n $chunkSize | sed 's/ /,/g' | xargs -n1 > tmp.txt);

while IFS= read -r line; do
    addEligible $line;
done < "./tmp.txt"

rm tmp.txt;

