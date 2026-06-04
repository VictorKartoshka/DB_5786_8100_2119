import ast
import re

with open('app.py', 'r', encoding='utf-8') as f:
    source = f.read()

tree = ast.parse(source)

replacements = []

for node in tree.body:
    if isinstance(node, ast.FunctionDef) and node.name.startswith('api_') and node.name != 'api_query_run' and node.name != 'api_routine_run':
        # Found an API function.
        # We will generate a new body for it.
        # Let's find the try block.
        try_node = None
        for stmt in node.body:
            if isinstance(stmt, ast.Try):
                try_node = stmt
                break
        
        if not try_node:
            continue
            
        action = node.name.split('_')[-1] # create, update, delete, fetch
        
        # Look for cur.execute calls
        executes = []
        for stmt in try_node.body:
            if isinstance(stmt, ast.Expr) and isinstance(stmt.value, ast.Call):
                call = stmt.value
                if isinstance(call.func, ast.Attribute) and call.func.attr == 'execute':
                    # Extract the SQL string. We can use ast.unparse on the arguments.
                    sql = ast.unparse(call.args[0])
                    params = ast.unparse(call.args[1]) if len(call.args) > 1 else None
                    executes.append((sql, params))
            elif isinstance(stmt, ast.Assign):
                # Sometimes row = cur.fetchone() or new_id = ...
                pass
                
        # Now we need to generate the new try block.
        # Wait, instead of rewriting the AST, let's just generate the whole function as a string!
        
        # Extract the original required fields logic
        req_lines = []
        for stmt in node.body:
            if stmt == try_node:
                break
            # Skip conn = get_db()
            if isinstance(stmt, ast.Assign) and ast.unparse(stmt.value).startswith('get_db('):
                continue
            req_lines.append(ast.unparse(stmt))
            
        new_body_str = "\n    ".join(req_lines)
        
        new_try_body = ""
        if action == 'create' and len(executes) == 2:
            sql1, _ = executes[0]
            sql2, params2 = executes[1]
            
            # The second SQL has the multi-line INSERT.
            # We need to replace %s in params with the subquery.
            # E.g. params2 = "(new_id, data['first_name'], ...)"
            if params2 and params2.startswith('(new_id,'):
                params2 = '(' + params2[8:].strip()
            elif params2 and params2 == 'new_id':
                params2 = '()'
                
            # Replace the first %s in sql2 with the subquery
            # sql1 is usually 'SELECT COALESCE(MAX(...),0)+1 FROM ...'
            sql1_clean = sql1.strip("'\"")
            
            # Since sql2 might be concatenated strings in ast.unparse, it comes out as a single string literal with \n or just concatenated.
            # ast.unparse evaluates implicit concatenation into a single string!
            sql2_clean = ast.literal_eval(sql2)
            
            # We replace the first %s with (SELECT ...)
            sql_final = sql2_clean.replace('%s', f'({sql1_clean})', 1)
            
            # Wrap in triple quotes just in case
            sql_repr = repr(sql_final)
            
            new_try_body += f"execute_db({sql_repr}, {params2})\n        return jsonify(success=True)"
            
        elif action in ['update', 'delete', 'create']: # create with 1 execute?
            sql, params = executes[0]
            sql_clean = ast.literal_eval(sql)
            new_try_body += f"execute_db({repr(sql_clean)}, {params})\n        return jsonify(success=True)"
            
        elif action == 'fetch':
            sql, params = executes[0]
            sql_clean = ast.literal_eval(sql)
            new_try_body += f"row, _ = query_db({repr(sql_clean)}, {params}, fetchone=True)\n        return jsonify(success=True, data=serialize_row(row))"
            
        new_func = f"""@app.route('/api/{node.name[4:]}/{action}', methods=['POST'])
@login_required
def {node.name}():
    {new_body_str}
    try:
        {new_try_body}
    except Exception as e:
        return jsonify(success=False, error=str(e))"""
        
        # We need to find the exact text in the file to replace.
        # We know the function starts at node.lineno and ends at try_node end_lineno.
        # Wait, decorators are NOT included in node.lineno in older pythons? In 3.9+ node.decorator_list has them.
        # It's easier to use a regex to find this specific function block in the source code!
        
        replacements.append((node.name, new_func))

# Now do the text replacement
for name, new_func in replacements:
    # Find the function in source
    pattern = re.compile(rf"@app\.route\([^)]+\)\n@login_required\ndef {name}\(\):.*?(?=\n@app\.route|\n# =|\Z)", re.DOTALL)
    match = pattern.search(source)
    if match:
        source = source[:match.start()] + new_func + source[match.end():]
    else:
        print(f"Could not find function block for {name}")

with open('app.py', 'w', encoding='utf-8') as f:
    f.write(source)

print("Refactoring complete.")
