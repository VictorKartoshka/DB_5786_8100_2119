import re

with open('app.py', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Replace conn.close() with release_db(conn)
content = content.replace('conn.close()', 'release_db(conn)')

# 2. Add release_db to the imports if not present
if 'release_db' not in content:
    content = content.replace('from db import get_db, query_db, execute_db', 'from db import get_db, query_db, execute_db, release_db')

# 3. Add @login_required to API routes
# We'll find all occurrences of `@app.route('/api/...` and if the next line is NOT `@login_required`, we insert it.
pattern = re.compile(r"(@app\.route\('/api/[^']+', methods=\['POST'\]\)\n)(?!@login_required)")
content = pattern.sub(r"\1@login_required\n", content)

with open('app.py', 'w', encoding='utf-8') as f:
    f.write(content)

print("done")
