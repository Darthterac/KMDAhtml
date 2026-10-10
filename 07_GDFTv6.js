javascript: (function () {
    const currentUrl = window.location.href;
    const isGD = currentUrl.includes('/wow/c/community/general-discussion');
    const isTopic = currentUrl.includes('/wow/t/');

    if (!isGD && !isTopic) {
        alert('Please run this bookmarklet on a WoW General Discussion page or a Topic page!');
        return;
    }

    if (isTopic) {
        function formatSeconds(sec) {
            if (!sec) return '0m';
            const h = Math.floor(sec / 3600);
            const m = Math.floor((sec % 3600) / 60);
            return h > 0 ? `${h}h ${m}m` : `${m}m`;
        }

        function formatDate(isoStr) {
            if (!isoStr) return 'N/A';
            return new Date(isoStr).toLocaleString();
        }

        // ==================== PRIVATE PROFILE TRACKING ====================
        function logPrivateProfileUser(userCard) {
            const privateProfiles = JSON.parse(
                localStorage.getItem('wow_private_profiles') || '{}'
            );
            
            if (!privateProfiles[userCard]) {
                privateProfiles[userCard] = {
                    firstSeen: new Date().toISOString(),
                    sightings: [],
                    altNames: []
                };
            }
            
            const entry = privateProfiles[userCard];
            entry.lastSeen = new Date().toISOString();
            entry.sightings.push({
                timestamp: new Date().toISOString(),
                topicUrl: window.location.href,
                topicTitle: document.title
            });
            
            // Keep only last 50 sightings per user
            if (entry.sightings.length > 50) {
                entry.sightings = entry.sightings.slice(-50);
            }
            
            localStorage.setItem('wow_private_profiles', JSON.stringify(privateProfiles));
        }

        function logAltAssociation(userCard, altName) {
            const privateProfiles = JSON.parse(
                localStorage.getItem('wow_private_profiles') || '{}'
            );
            
            if (!privateProfiles[userCard]) {
                privateProfiles[userCard] = {
                    firstSeen: new Date().toISOString(),
                    sightings: [],
                    altNames: []
                };
            }
            
            if (!privateProfiles[userCard].altNames.includes(altName)) {
                privateProfiles[userCard].altNames.push(altName);
            }
            
            localStorage.setItem('wow_private_profiles', JSON.stringify(privateProfiles));
        }
        // =====================================================================

        function inspectTopicUsers() {
            document.querySelectorAll('a.character-name').forEach(el => {
                if (el.dataset.customDataInjected) return;
                const userCard = el.getAttribute('data-user-card');
                if (!userCard) return;
                el.dataset.customDataInjected = 'pending';

                fetch(`${window.location.origin}/en/wow/u/${userCard}.json`)
                    .then(res => res.json())
                    .then(data => {
                        const profile = data.user || data;
                        const lastSeen = formatDate(profile.last_seen_at);
                        const lastPost = formatDate(profile.last_posted_at);
                        const readTime = formatSeconds(profile.recent_time_read);
                        let maxTrust = profile.trust_level || 0;
                        
                        // Check if profile is private
                        const isPrivate = !profile.last_seen_at && !profile.last_posted_at;
                        
                        if (isPrivate) {
                            logPrivateProfileUser(userCard);
                        }
                        
                        if (profile.groups && Array.isArray(profile.groups)) {
                            profile.groups.forEach(g => {
                                const gName = typeof g === 'string' ? g : (g.name || '');
                                const match = gName.match(/trust_level_(\d+)/);
                                if (match) {
                                    const lvl = parseInt(match[1], 10);
                                    if (lvl > maxTrust) maxTrust = lvl;
                                }
                            });
                        }

                        const container = document.createElement('div');
                        container.style.fontSize = '11px';
                        container.style.color = isPrivate ? '#ff6b6b' : '#38bdf8';
                        container.style.marginTop = '4px';
                        container.style.lineHeight = '1.2';
                        container.innerHTML = `
                            <div><strong>[ID: ${userCard}]${isPrivate ? ' 🔒 PRIVATE' : ''}</strong></div>
                            <div>last seen: ${lastSeen}</div>
                            <div>last post: ${lastPost}</div>
                            <div>read time: ${readTime}</div>
                            <div>trust level: ${maxTrust}</div>
                        `;
                        el.parentNode.appendChild(container);
                        el.dataset.customDataInjected = 'true';
                    })
                    .catch(err => console.error("Fetch error:", err));
            });
        }

        inspectTopicUsers();

        if (!window.topicInspectorInterval) {
            window.topicInspectorInterval = setInterval(inspectTopicUsers, 3000);
        }

        if (!window.topicInspectorScroll) {
            window.topicInspectorScroll = window.addEventListener('wheel', (e) => {
                if (e.deltaY > 0) inspectTopicUsers();
            }, { passive: true });
        }

        if (!window.topicInspectorKey) {
            window.topicInspectorKey = window.addEventListener('keydown', (e) => {
                if (e.key === 'ArrowDown') inspectTopicUsers();
            });
        }

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
        localStorage.getItem('wow_ignore_list')
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
        max-height: 80vh;
        overflow-y: auto;
    `;

    modal.innerHTML = `
        <h3 style="margin-top: 0; color: #4470bb; font-size: 14px;">
            GD Forum Tools
        </h3>

        <p>©MIT Lazyeyez</p>

        <p style="font-size: 12px; color: #2eb689c5; margin-bottom: 6px;">
            Enter the Users ID you wish to ignore (Logged in as: ${appUserId})
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

        <div style="margin-top: 12px; display: flex; justify-content: space-between; gap: 8px;">
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
                    flex: 1;
                    font-size: 11px;
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
                    flex: 1;
                    font-size: 11px;
                "
            >Exit</button>
        </div>

        <button
            id="fools-view-private"
            style="
                background: #1a472a;
                color: #4ade80;
                border: 1px solid #22c55e;
                padding: 8px 14px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 11px;
                width: 100%;
                margin-top: 12px;
            "
        >📋 View Private Profiles</button>

        <button
            id="fools-export-private"
            style="
                background: #472a2a;
                color: #ffa500;
                border: 1px solid #ff8c00;
                padding: 8px 14px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 11px;
                width: 100%;
                margin-top: 8px;
            "
        >📥 Export CSV</button>
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

    document.getElementById('fools-view-private').onclick = () => {
        const privateProfiles = JSON.parse(
            localStorage.getItem('wow_private_profiles') || '{}'
        );
        
        let report = 'PRIVATE PROFILE TRACKING\n';
        report += '='.repeat(60) + '\n\n';
        
        const count = Object.keys(privateProfiles).length;
        if (count === 0) {
            report += 'No private profiles tracked yet.\n';
        } else {
            for (const [userCard, data] of Object.entries(privateProfiles)) {
                report += `[${userCard}]\n`;
                report += `  First Seen: ${new Date(data.firstSeen).toLocaleString()}\n`;
                report += `  Last Seen: ${new Date(data.lastSeen).toLocaleString()}\n`;
                report += `  Total Sightings: ${data.sightings.length}\n`;
                if (data.altNames && data.altNames.length > 0) {
                    report += `  Possible Alts: ${data.altNames.join(', ')}\n`;
                }
                report += '\n';
            }
        }
        
        const reportModal = document.createElement('div');
        reportModal.style.cssText = `
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 9999999;
            background: #121212;
            color: #e0e0e0;
            border: 2px solid #22c55e;
            padding: 20px;
            border-radius: 8px;
            width: 600px;
            max-height: 500px;
            overflow-y: auto;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.9);
        `;
        
        reportModal.innerHTML = `
            <h3 style="color: #4ade80; margin-top: 0;">Private Profile Log (${count} users)</h3>
            <textarea readonly style="
                width: 100%;
                height: 350px;
                background: #1e1e1e;
                color: #4ade80;
                border: 1px solid #22c55e;
                border-radius: 4px;
                padding: 8px;
                box-sizing: border-box;
                font-family: monospace;
                font-size: 11px;
            ">${report}</textarea>
            <div style="margin-top: 12px; display: flex; gap: 8px;">
                <button onclick="this.parentElement.parentElement.remove()" style="
                    background: #5627a6;
                    color: #8ecbef;
                    border: none;
                    padding: 8px 14px;
                    border-radius: 4px;
                    cursor: pointer;
                    flex: 1;
                ">Close</button>
                <button onclick="navigator.clipboard.writeText(document.querySelector('#reportText').value); alert('Copied to clipboard!');" style="
                    background: #22c55e;
                    color: #000;
                    border: none;
                    padding: 8px 14px;
                    border-radius: 4px;
                    cursor: pointer;
                    flex: 1;
                    font-weight: bold;
                ">Copy</button>
            </div>
        `;
        
        // Add hidden textarea for clipboard
        const hiddenArea = document.createElement('textarea');
        hiddenArea.id = 'reportText';
        hiddenArea.value = report;
        hiddenArea.style.display = 'none';
        reportModal.appendChild(hiddenArea);
        
        document.body.appendChild(reportModal);
    };

    document.getElementById('fools-export-private').onclick = () => {
        const privateProfiles = JSON.parse(
            localStorage.getItem('wow_private_profiles') || '{}'
        );
        
        let csv = 'UserCard,FirstSeen,LastSeen,TotalSightings,Alts\n';
        
        for (const [userCard, data] of Object.entries(privateProfiles)) {
            const alts = data.altNames ? data.altNames.join(';') : '';
            csv += `"${userCard}","${data.firstSeen}","${data.lastSeen}",${data.sightings.length},"${alts}"\n`;
        }
        
        const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `wow-private-profiles-${new Date().toISOString().split('T')[0]}.csv`;
        link.click();
        alert('CSV exported!');
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

                        alert(`${cardToUnignore} is now unignored.`);
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
