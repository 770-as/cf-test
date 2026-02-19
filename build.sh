
echo "--- DEBUG: Checking if the secret was baked into the file ---"
grep "token" public/index.html
TOKEN=$CLOUDFLARE_API_TOKEN
ACCOUNT_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/accounts" \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" | sed -n 's/.*"id":"\([^"]*\)".*/\1/p' | head -n 1)
curl "https://api.cloudflare.com/client/v4/accounts/3514ad102b78d8da0986b1def65b00b6/d1/database" \
  -H "Authorization: Bearer $TOKEN"
curl "https://api.cloudflare.com/client/v4/accounts/3514ad102b78d8da0986b1def65b00b6/d1/database/<DATABASE_UUID>/query" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "sql": "SELECT * FROM users LIMIT 10;"
  }'
curl "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/d1/database" \
  -H "Authorization: Bearer $TOKEN"
curl -X POST "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/d1/database/$DATABASE_ID/query" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{ "sql": "SELECT name FROM sqlite_master WHERE type=\"table\";" }'
curl "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/r2/buckets" \
  -H "Authorization: Bearer $TOKEN"
curl "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/scripts/$SCRIPT_NAME/secrets" \
  -H "Authorization: Bearer $TOKEN"
curl "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/workers/scripts" \
  -H "Authorization: Bearer $TOKEN"
curl "https://api.cloudflare.com/client/v4/user/tokens/verify" \
  -H "Authorization: Bearer $TOKEN"
curl "https://cf-test.shmouely.workers.dev/.git/HEAD"
curl "https://api.cloudflare.com/client/v4/accounts/3514ad102b78d8da0986b1def65b00b6/workers/scripts/cf-test/secrets" \
  -H "Authorization: Bearer <TOKEN>"




  

