/* ============================================================
   LUXE DINE — Main JavaScript
   Shared utilities for CRUD, modals, toasts, and star ratings
   ============================================================ */

// ── Toast Notifications ──────────────────────────────────────

function showToast(message, type = 'info') {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.innerHTML = `
        <span>${message}</span>
        <button class="close-toast" onclick="this.parentElement.remove()">&times;</button>
    `;
    container.appendChild(toast);

    // Auto-dismiss after 4 seconds
    setTimeout(() => {
        toast.style.opacity = '0';
        toast.style.transform = 'translateX(100px)';
        setTimeout(() => toast.remove(), 300);
    }, 4000);
}

// ── Modal Management ─────────────────────────────────────────

function openModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (overlay) {
        overlay.classList.add('active');
    }
}

function closeModal(modalId) {
    const overlay = document.getElementById(modalId);
    if (overlay) {
        overlay.classList.remove('active');
        // Reset forms inside
        const forms = overlay.querySelectorAll('form');
        forms.forEach(f => f.reset());
        // Hide edit fields if any
        const editFields = overlay.querySelector('.edit-fields');
        if (editFields) editFields.classList.add('hidden');
    }
}

// Close modal when clicking on overlay background
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay') && e.target.classList.contains('active')) {
        e.target.classList.remove('active');
    }
});

// ── CRUD Operations ──────────────────────────────────────────

async function createRecord(tableName, formEl) {
    const formData = new FormData(formEl);
    const data = Object.fromEntries(formData.entries());

    // Check that required fields (those with 'required' attribute) are not empty
    const requiredInputs = formEl.querySelectorAll('[required]');
    let hasEmpty = false;
    requiredInputs.forEach(input => {
        if (!input.value || input.value.trim() === '') {
            hasEmpty = true;
            input.style.borderColor = 'var(--danger)';
        } else {
            input.style.borderColor = '';
        }
    });
    if (hasEmpty) {
        showToast('Please fill in all required fields', 'warning');
        return;
    }

    // Remove truly optional empty strings (not required fields)
    Object.keys(data).forEach(k => {
        if (data[k] === '') data[k] = null;
    });

    try {
        const res = await fetch(`/api/${tableName}/create`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();
        if (result.success) {
            showToast('Record created successfully!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast('Error: ' + result.error, 'error');
        }
    } catch (e) {
        showToast('Network error: ' + e.message, 'error');
    }
}

async function fetchRecord(tableName, pkValue) {
    if (!pkValue) {
        showToast('Please enter an ID', 'error');
        return;
    }
    try {
        const res = await fetch(`/api/${tableName}/fetch`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: pkValue })
        });
        const result = await res.json();
        if (result.success && result.data) {
            // Find the closest modal and populate form fields
            const forms = document.querySelectorAll('.modal.active form, .modal-overlay.active form');
            let form = forms.length > 0 ? forms[0] : null;

            // Fallback: find any visible edit form
            if (!form) {
                form = document.querySelector('.modal-overlay.active .modal-body form');
            }

            if (form) {
                Object.keys(result.data).forEach(key => {
                    const input = form.querySelector(`[name="${key}"]`);
                    if (input) {
                        input.value = result.data[key] !== null ? result.data[key] : '';
                    }
                });
            }

            // Show the edit fields section
            const editFields = document.querySelector('.modal-overlay.active .edit-fields');
            if (editFields) editFields.classList.remove('hidden');

            showToast('Record loaded', 'info');
        } else {
            showToast('Error: ' + (result.error || 'Record not found'), 'error');
        }
    } catch (e) {
        showToast('Network error: ' + e.message, 'error');
    }
}

async function updateRecord(tableName, formEl) {
    const formData = new FormData(formEl);
    const data = Object.fromEntries(formData.entries());

    try {
        const res = await fetch(`/api/${tableName}/update`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        });
        const result = await res.json();
        if (result.success) {
            showToast('Record updated successfully!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast('Error: ' + result.error, 'error');
        }
    } catch (e) {
        showToast('Network error: ' + e.message, 'error');
    }
}

async function deleteRecord(tableName, pkValue) {
    try {
        const res = await fetch(`/api/${tableName}/delete`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: pkValue })
        });
        const result = await res.json();
        if (result.success) {
            showToast('Record deleted successfully!', 'success');
            setTimeout(() => location.reload(), 1000);
        } else {
            showToast('Error: ' + result.error, 'error');
        }
    } catch (e) {
        showToast('Network error: ' + e.message, 'error');
    }
}

// ── Star Rating Picker ───────────────────────────────────────

function initStarRating() {
    document.querySelectorAll('.star-rating-input').forEach(container => {
        const stars = container.querySelectorAll('.star');
        const input = container.querySelector('input[type="hidden"]');

        stars.forEach((star, index) => {
            star.addEventListener('click', () => {
                const value = index + 1;
                if (input) input.value = value;
                stars.forEach((s, i) => {
                    s.classList.toggle('filled', i < value);
                    s.classList.toggle('empty', i >= value);
                });
            });

            star.addEventListener('mouseenter', () => {
                stars.forEach((s, i) => {
                    s.style.opacity = i <= index ? '1' : '0.4';
                });
            });

            star.addEventListener('mouseleave', () => {
                stars.forEach(s => s.style.opacity = '1');
            });
        });
    });
}

// ── Tab Switching ────────────────────────────────────────────

function switchTab(tabName) {
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    const btn = document.querySelector(`[data-tab="${tabName}"]`);
    const panel = document.getElementById(`panel-${tabName}`);
    if (btn) btn.classList.add('active');
    if (panel) panel.classList.add('active');
}

// ── Query & Routine Helpers ──────────────────────────────────

async function runQuery(queryId) {
    const container = document.getElementById('queryResults');
    if (!container) return;
    container.innerHTML = '<p class="text-muted" style="padding:1rem;">Running query...</p>';

    try {
        const res = await fetch('/api/query/run', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ query_id: queryId })
        });
        const data = await res.json();
        if (data.success) {
            renderResultsTable(container, data.data, data.columns);
            showToast('Query executed successfully', 'success');
        } else {
            container.innerHTML = `<p class="text-danger" style="padding:1rem;">${data.error}</p>`;
            showToast('Query failed: ' + data.error, 'error');
        }
    } catch (e) {
        container.innerHTML = `<p class="text-danger" style="padding:1rem;">Error: ${e.message}</p>`;
        showToast('Network error', 'error');
    }
}

async function runRoutine(routineId, params) {
    const resultDiv = document.getElementById(`result-${routineId}`);
    if (!resultDiv) return;
    resultDiv.innerHTML = '<p class="text-muted" style="padding:1rem;">Executing...</p>';

    try {
        const res = await fetch('/api/routine/run', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ routine_id: routineId, ...params })
        });
        const data = await res.json();
        if (data.success) {
            if (data.data && Array.isArray(data.data) && data.data.length > 0) {
                renderResultsTable(resultDiv, data.data, data.columns);
            } else {
                resultDiv.innerHTML = `
                    <div class="card" style="margin-top:1rem;padding:1.5rem;border-color:var(--accent-gold);">
                        <p class="text-gold" style="font-size:1.1rem;font-weight:500;">
                            ✅ ${data.message || 'Executed successfully'}
                        </p>
                    </div>`;
            }
            showToast('Routine executed successfully', 'success');
        } else {
            resultDiv.innerHTML = `<p class="text-danger" style="padding:1rem;">${data.error}</p>`;
            showToast('Execution failed: ' + data.error, 'error');
        }
    } catch (e) {
        resultDiv.innerHTML = `<p class="text-danger" style="padding:1rem;">Error: ${e.message}</p>`;
        showToast('Network error', 'error');
    }
}

function renderResultsTable(container, rows, columns) {
    if (!rows || rows.length === 0) {
        container.innerHTML = '<p class="text-muted" style="padding:1rem;">No results found.</p>';
        return;
    }
    const cols = columns || Object.keys(rows[0]);
    let html = '<div class="table-wrapper" style="margin-top:1rem;"><table class="data-table"><thead><tr>';
    cols.forEach(c => {
        const label = c.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
        html += `<th>${label}</th>`;
    });
    html += '</tr></thead><tbody>';
    rows.forEach(row => {
        html += '<tr>';
        cols.forEach(c => {
            let val = row[c];
            if (val === null || val === undefined) val = '—';
            html += `<td>${val}</td>`;
        });
        html += '</tr>';
    });
    html += '</tbody></table></div>';
    container.innerHTML = html;
}

// ── Initialize on DOM Ready ──────────────────────────────────

document.addEventListener('DOMContentLoaded', () => {
    initStarRating();
});
