<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>YMenu - Key Generator</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', sans-serif; background: #0a0814; min-height: 100vh; display: flex; align-items: center; justify-content: center; color: #fff; }
        .card { background: rgba(18,15,35,0.95); border-radius: 20px; padding: 35px; border: 1px solid rgba(130,80,255,0.2); box-shadow: 0 0 60px rgba(130,80,255,0.1); max-width: 550px; width: 90%; }
        .title { font-size: 28px; font-weight: 800; background: linear-gradient(135deg, #a855f7, #7c3aed); -webkit-background-clip: text; -webkit-text-fill-color: transparent; text-align: center; margin-bottom: 5px; }
        .sub { text-align: center; color: rgba(180,170,210,0.6); font-size: 12px; margin-bottom: 25px; }
        label { display: block; color: rgba(200,190,230,0.8); font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 1.5px; margin-bottom: 8px; }
        input, select { width: 100%; padding: 12px 16px; background: rgba(30,25,55,0.8); border: 1px solid rgba(130,80,255,0.15); border-radius: 10px; color: #fff; font-size: 14px; font-family: 'Inter', sans-serif; outline: none; margin-bottom: 15px; }
        input:focus { border-color: rgba(130,80,255,0.5); }
        .row { display: flex; gap: 12px; }
        .row > div { flex: 1; }
        .btn { width: 100%; padding: 14px; background: linear-gradient(135deg, #7c3aed, #a855f7); border: none; border-radius: 10px; color: #fff; font-size: 14px; font-weight: 700; cursor: pointer; transition: all 0.3s; margin-bottom: 10px; }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 8px 30px rgba(130,80,255,0.3); }
        .btn-green { background: linear-gradient(135deg, #059669, #10b981); }
        .btn-green:hover { box-shadow: 0 8px 30px rgba(16,185,129,0.3); }
        .output { background: rgba(15,12,30,0.9); border: 1px solid rgba(130,80,255,0.1); border-radius: 10px; padding: 15px; min-height: 120px; max-height: 250px; overflow-y: auto; font-family: monospace; font-size: 13px; color: #c084fc; white-space: pre-line; word-break: break-all; margin-bottom: 15px; }
        .status { padding: 10px 14px; border-radius: 8px; font-size: 12px; margin-bottom: 10px; display: none; }
        .status.ok { display: block; background: rgba(34,197,94,0.1); border: 1px solid rgba(34,197,94,0.3); color: #4ade80; }
        .status.err { display: block; background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3); color: #f87171; }
        .status.info { display: block; background: rgba(130,80,255,0.1); border: 1px solid rgba(130,80,255,0.3); color: #c084fc; }
        .config { margin-bottom: 20px; padding: 15px; background: rgba(25,20,45,0.5); border-radius: 10px; border: 1px solid rgba(130,80,255,0.1); }
        .config-title { font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; color: rgba(130,80,255,0.6); margin-bottom: 12px; }
    </style>
</head>
<body>
    <div class="card">
        <div class="title">🔑 Key Generator</div>
        <p class="sub">Generate keys & upload to GitHub</p>

        <div class="config">
            <div class="config-title">GitHub Settings</div>
            <label>GitHub Token</label>
            <input type="password" id="token" placeholder="ghp_xxxxxxxxxxxx">
            <div class="row">
                <div><label>Owner</label><input id="owner" value="Ygariqi"></div>
                <div><label>Repo</label><input id="repo" value="YMenu"></div>
            </div>
        </div>

        <div class="row">
            <div><label>Number of keys</label><input type="number" id="count" value="5" min="1" max="50"></div>
            <div><label>Prefix</label><input id="prefix" value="YMENU"></div>
        </div>

        <button class="btn" onclick="generateKeys()">⚡ Generate Keys</button>

        <div class="output" id="output">Keys will appear here...</div>

        <button class="btn btn-green" onclick="uploadToGithub()">📤 Upload to GitHub</button>
        <button class="btn" style="background: rgba(50,45,80,0.8);" onclick="copyKeys()">📋 Copy Keys</button>

        <div class="status" id="status"></div>
    </div>

    <script>
        let generatedKeys = [];

        function randomHex(len) {
            const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
            let s = '';
            for (let i = 0; i < len; i++) s += chars[Math.floor(Math.random() * chars.length)];
            return s;
        }

        function generateKeys() {
            const count = parseInt(document.getElementById('count').value) || 5;
            const prefix = document.getElementById('prefix').value || 'YMENU';
            generatedKeys = [];
            for (let i = 0; i < count; i++) {
                generatedKeys.push(`${prefix}-${randomHex(5)}-${randomHex(5)}-${randomHex(5)}`);
            }
            document.getElementById('output').textContent = generatedKeys.join('\n');
        }

        function copyKeys() {
            if (!generatedKeys.length) return;
            navigator.clipboard.writeText(generatedKeys.join('\n'));
            showStatus('📋 Keys copied to clipboard!', 'ok');
        }

        function showStatus(msg, type) {
            const s = document.getElementById('status');
            s.className = 'status ' + type;
            s.textContent = msg;
        }

        async function uploadToGithub() {
            if (!generatedKeys.length) { showStatus('Generate keys first!', 'err'); return; }
            const token = document.getElementById('token').value;
            if (!token) { showStatus('Enter your GitHub token!', 'err'); return; }

            const owner = document.getElementById('owner').value;
            const repo = document.getElementById('repo').value;
            showStatus('⏳ Uploading to GitHub...', 'info');

            try {
                // Get current keys file (or create new)
                let sha = null;
                let existingKeys = [];
                try {
                    const res = await fetch(`https://api.github.com/repos/${owner}/${repo}/contents/YMenu_Keys.txt?ref=main`, {
                        headers: { 'Authorization': `token ${token}`, 'Accept': 'application/vnd.github.v3+json' }
                    });
                    if (res.ok) {
                        const data = await res.json();
                        sha = data.sha;
                        existingKeys = atob(data.content).split('\n').map(s => s.trim()).filter(s => s);
                    }
                } catch(e) {}

                // Merge keys
                const allKeys = [...existingKeys, ...generatedKeys];
                const content = allKeys.join('\n') + '\n';

                // Upload
                const body = { message: `Add ${generatedKeys.length} new keys`, content: btoa(content), branch: 'main' };
                if (sha) body.sha = sha;

                const res = await fetch(`https://api.github.com/repos/${owner}/${repo}/contents/YMenu_Keys.txt`, {
                    method: 'PUT',
                    headers: { 'Authorization': `token ${token}`, 'Accept': 'application/vnd.github.v3+json', 'Content-Type': 'application/json' },
                    body: JSON.stringify(body)
                });

                if (!res.ok) throw new Error('GitHub API error');
                showStatus(`✅ ${generatedKeys.length} keys uploaded to GitHub!`, 'ok');
            } catch(err) {
                showStatus('❌ Error: ' + err.message, 'err');
            }
        }
    </script>
</body>
</html>
