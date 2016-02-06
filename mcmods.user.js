// ==UserScript==
// @name         Atom Mediawiki Edit
// @match        http://mcmods.gigavoid.com/*
// @grant        none
// ==/UserScript==
/* jshint -W097 */
'use strict';

if (/[\?&]action=edit/.exec(window.location.search)) {
    edit(getTitle(window.location.search));
}

document.querySelector('#ca-edit a').addEventListener('click', function (e) {
    e.preventDefault();
    edit(getTitle(e.target.href));
});

function edit(page) {
    $.ajax({
        url: 'http://localhost:5909/edit/' + page,
        headers: {
            'Api-Endpoint': 'http://mcmods.gigavoid.com/api.php',
            'Token': '+\\'
        }
    });
}

function getTitle(str) {
    return /[?&]title=([A-Za-z0-9_-]*)/.exec(window.location.search)[1];
}
