javascript: (function () {
    if (!window.location.href.includes('/wow/c/community/general-discussion')) {
        alert('Please run this bookmarklet on the WoW General Discussion page!');
        return;
    }

    let appUserId = localStorage.getItem('wow_app_user_id');
    if (!appUserId) {
        appUserId = prompt('GD Forum Tools: Please enter your Blizzard Forum User ID (e.g., panthra-2938857):');
        if (appUserId) {
            localStorage.setItem('wow_app_user_id', appUserId.trim());
        } else {
            return;
        }
    }

    let modal = document.getElementById('fools-filter-modal');

    if (modal) {
        modal.style.display = modal.style.display === 'none' ? 'block' : 'none';
        return;
    }

    let ignoreList = JSON.parse(
        localStorage.getItem('wow_ignore_list') || '["Thallia-2277436"]'
    );

    modal = document.createElement('div');
    modal.id = 'fools-filter-modal';

    modal.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 999999;
        background: #121212;
        color: #e0e0e0;
        border: 1px solid #333;
        padding: 20px;
        border-radius: 8px;
        font-family: sans-serif;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.8);
        width: 340px;
    `;

    modal.innerHTML = `
        <h3 style="margin-top: 0; color: #2269e3; font-size: 16px;">
                         GD Forum Tools
        </h3>
        
        <p style="font-size: 10px; color: #00ff15;margin-left: 6px">
            Supplied User ID: [ ${appUserId} ]
        </p>
        
        <p style="font-size: 8px; color: #798ad6c5;margin-right: 6px">
            MIT ©2026 Lazyeyez
        </p>

        <p style="font-size: 10px; color: #b1de0f; margin-bottom: 6px;">
            Enter the Users ID you wish to ignore:
        </p>

        <div id="fools-status" style="font-size: 11px; color: #8ecbef; margin-bottom: 8px; font-family: monospace;">
            Connecting to Blizzard profile...
        </div>

        <textarea
            id="fools-input"
            style="
                width: 100%;
                height: 100px;
                background: #1e1e1e;
                color: #fff;
                border: 1px solid #444;
                border-radius: 4px;
                padding: 8px;
                box-sizing: border-box;
                font-family: monospace;
            "
        >${ignoreList.join('\n')}</textarea>

        <div style="margin-top: 12px; display: flex; justify-content: space-between;">
            <button
                id="fools-save"
                style="
                    background: #5627a6;
                    color: #8ecbef;
                    border: none;
                    padding: 8px 14px;
                    font-weight: bold;
                    border-radius: 4px;
                    cursor: pointer;
                "
            >Save Apply</button>

            <button
                id="fools-close"
                style="
                    background: #5627a6;
                    color: #8ecbef;
                    border: none;
                    padding: 8px 14px;
                    border-radius: 4px;
                    cursor: pointer;
                "
            >Exit</button>
        </div>
    `;

    document.body.appendChild(modal);

    document.getElementById('fools-close').onclick = () => modal.remove();

    document.getElementById('fools-save').onclick = () => {
        const val = document.getElementById('fools-input').value;

        const newList = val
            .split(/[\n,]+/)
            .map(s => s.trim())
            .filter(Boolean);

        localStorage.setItem('wow_ignore_list', JSON.stringify(newList));

        modal.remove();
        applyFilter();
    };

    async function syncNativeIgnores() {
        const statusEl = document.getElementById('fools-status');
        const textarea = document.getElementById('fools-input');
        if (!appUserId || !statusEl || !textarea) return;

        try {
            const url = `${window.location.origin}/en/wow/u/${appUserId}.json`;
            const response = await fetch(url);
            if (!response.ok) {
                statusEl.style.color = '#ff5555';
                statusEl.textContent = '⚠️ Failed to fetch profile JSON.';
                return;
            }

            const data = await response.json();
            if (data && data.user && Array.isArray(data.user.ignored_usernames)) {
                const nativeIgnores = data.user.ignored_usernames;
                
                if (nativeIgnores.length > 0) {
                    statusEl.style.color = '#2eb689';
                    statusEl.textContent = `✓ Synced ${nativeIgnores.length} user(s) from Blizzard!`;

                    const currentLines = textarea.value.split(/[\n,]+/).map(s => s.trim()).filter(Boolean);
                    const combined = [...new Set([...currentLines, ...nativeIgnores])];
                    
                    textarea.value = combined.join('\n');
                    localStorage.setItem('wow_ignore_list', JSON.stringify(combined));
                } else {
                    statusEl.style.color = '#8ecbef';
                    statusEl.textContent = '✓ Connected (No native ignores found).';
                }
            }
        } catch (error) {
            statusEl.style.color = '#ff5555';
            statusEl.textContent = '⚠️ Error syncing with Blizzard.';
        }
    }

    syncNativeIgnores();

    async function applyFilter() {
        const currentIgnores = JSON.parse(
            localStorage.getItem('wow_ignore_list') || '[]'
        );

        if (currentIgnores.length === 0) return;

        const rows = document.querySelectorAll(
            'table.topic-list tbody.topic-list-body tr.topic-list-item'
        );

        rows.forEach(row => {
            if (row.dataset.foolsProcessed === 'true') return;

            const userCardElements = row.querySelectorAll('[data-user-card]');
            let matched = false;
            let matchedCard = '';

            userCardElements.forEach(el => {
                const cardValue = el.getAttribute('data-user-card') || '';

                currentIgnores.forEach(ignore => {
                    if (cardValue.toLowerCase() === ignore.toLowerCase()) {
                        matched = true;
                        matchedCard = cardValue;
                    }
                });
            });

            if (matched) {
                row.dataset.foolsProcessed = 'true';

                row.innerHTML = `
                    <td colspan="5" style="padding: 4px 0;">
                        <div class="fools-banner" style="
                            background: #373321;
                            color: #018bedc2;
                            padding: 10px 15px;
                            font-weight: bold;
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                            border: 1px solid #011a7d;
                            border-radius: 4px;
                            font-family: monospace;
                            width: 100%;
                            box-sizing: border-box;
                        ">
                            <span>[ Have a Nice Day! (${matchedCard}) ]</span>
                            <button class="fools-unignore-btn" data-card="${matchedCard}" style="
                                background: #5627a6;
                                color: #8ecbef;
                                border: none;
                                padding: 6px 12px;
                                border-radius: 4px;
                                cursor: pointer;
                                font-family: monospace;
                                font-weight: bold;
                                font-size: 11px;
                            ">Unignore to View</button>
                        </div>
                    </td>
                `;

                const bannerDiv = row.querySelector('.fools-banner');
                if (bannerDiv) {
                    bannerDiv.addEventListener('click', (e) => {
                        e.stopPropagation();
                        e.preventDefault();
                    });
                }

                const unignoreBtn = row.querySelector('.fools-unignore-btn');
                if (unignoreBtn) {
                    unignoreBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        e.preventDefault();
                        const cardToUnignore = unignoreBtn.getAttribute('data-card');

                        let ignores = JSON.parse(localStorage.getItem('wow_ignore_list') || '[]');
                        ignores = ignores.filter(c => c.toLowerCase() !== cardToUnignore.toLowerCase());
                        localStorage.setItem('wow_ignore_list', JSON.stringify(ignores));

                        alert(`${cardToUnignore} is now unignored.\nREFRESH PAGE AND RESTART GDFORUMTOOL!`);
                        window.location.reload();
                    });
                }
            }
        });
    }

    applyFilter();

    if (!window.foolsInterval) {
        window.foolsInterval = setInterval(applyFilter, 3000);
    }

    if (!window.foolsScrollListener) {
        window.foolsScrollListener = window.addEventListener(
            'wheel',
            (e) => {
                if (e.deltaY > 0) {
                    applyFilter();
                }
            },
            { passive: true }
        );
    }

    if (!window.foolsKeyListener) {
        window.foolsKeyListener = window.addEventListener(
            'keydown',
            (e) => {
                if (e.key === 'ArrowDown') {
                    applyFilter();
                }
            }
        );
    }
})();