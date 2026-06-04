import ast
import re

# Restore from backup first to have a clean slate!
with open('app.py.bak', 'r', encoding='utf-8') as f:
    source = f.read()

tree = ast.parse(source)

replacements = []

for node in tree.body:
    if isinstance(node, ast.FunctionDef) and node.name.startswith('api_') and node.name not in ('api_query_run', 'api_routine_run'):
        try_node = None
        for stmt in node.body:
            if isinstance(stmt, ast.Try):
                try_node = stmt
                break
        
        if not try_node:
            continue
            
        action = node.name.split('_')[-1]
        resource = node.name[4:-(len(action)+1)]
        
        executes = []
        for stmt in try_node.body:
            if isinstance(stmt, ast.Expr) and isinstance(stmt.value, ast.Call):
                call = stmt.value
                if isinstance(call.func, ast.Attribute) and call.func.attr == 'execute':
                    sql = ast.unparse(call.args[0])
                    params = ast.unparse(call.args[1]) if len(call.args) > 1 else None
                    executes.append((sql, params))
        
        new_try_body = ""
        req_fields = []
        
        if action == 'create' and len(executes) == 2:
            sql1, _ = executes[0]
            sql2, params2 = executes[1]
            if params2 and params2.startswith('(new_id,'):
                params2 = '(' + params2[8:].strip()
            elif params2 and params2 == 'new_id':
                params2 = '()'
            sql1_clean = sql1.strip("'\"")
            sql2_clean = ast.literal_eval(sql2)
            sql_final = sql2_clean.replace('%s', f'({sql1_clean})', 1)
            new_try_body += f"execute_db({repr(sql_final)}, {params2})\n        return jsonify(success=True)"
            
            # Extract req fields from params2
            req_matches = re.findall(r"data\['([^']+)'\]", params2)
            req_fields.extend(req_matches)
            
        elif action in ['update', 'delete', 'create']:
            sql, params = executes[0]
            sql_clean = ast.literal_eval(sql)
            new_try_body += f"execute_db({repr(sql_clean)}, {params})\n        return jsonify(success=True)"
            if params:
                req_fields.extend(re.findall(r"data\['([^']+)'\]", params))
                
        elif action == 'fetch':
            sql, params = executes[0]
            sql_clean = ast.literal_eval(sql)
            new_try_body += f"row, _ = query_db({repr(sql_clean)}, {params}, fetchone=True)\n        return jsonify(success=True, data=serialize_row(row))"
            if params:
                req_fields.extend(re.findall(r"data\['([^']+)'\]", params))
        
        # Build validation logic
        req_lines = ["data = request.json"]
        if req_fields:
            # unique fields, preserving order
            seen = set()
            unique_req = [x for x in req_fields if not (x in seen or seen.add(x))]
            req_str = "[" + ", ".join(f"'{f}'" for f in unique_req) + "]"
            req_lines.append(f"required = {req_str}")
            req_lines.append("if not all(k in data for k in required):")
            req_lines.append("    return jsonify(success=False, error=\"Missing required fields\")")
            
        new_body_str = "\n    ".join(req_lines)
        
        new_func = f"""@app.route('/api/{resource}/{action}', methods=['POST'])
@login_required
def {node.name}():
    {new_body_str}
    try:
        {new_try_body}
    except Exception as e:
        return jsonify(success=False, error=str(e))"""
        
        replacements.append((node.name, new_func))

# Now do the text replacement
for name, new_func in replacements:
    # Use re.sub to replace exactly the block
    pattern = re.compile(rf"@app\.route\([^)]+\)\ndef {name}\(\):.*?(?=\n@app\.route|\n# =|\Z)", re.DOTALL)
    # Note: app.py.bak did NOT have @login_required decorators!
    match = pattern.search(source)
    if match:
        source = source[:match.start()] + new_func + source[match.end():]
    else:
        print(f"Could not find function block for {name}")

# Also need to make sure release_db is imported if needed, though we don't need it for execute_db.
# Wait, execute_db is already in app.py.bak imports: "from db import get_db, query_db, execute_db"

with open('app.py', 'w', encoding='utf-8') as f:
    f.write(source)

print("Refactoring complete.")
