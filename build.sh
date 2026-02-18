echo "--- STARTING RECON ---"
echo "Who am I?"
id
echo "--- CHECKING THE DESK (Environment Variables) ---"
printenv
echo "--- CHECKING THE ENGINE (Kernel Version) ---"
uname -a
echo "--- LOOKING FOR NEIGHBORS (Internal Network) ---"
curl -I http://169.254.169.254/ --connect-timeout 2
echo "--- FINISHED ---"
