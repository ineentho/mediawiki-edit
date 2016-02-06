// ==UserScript==
// @name         Atom Mediawiki Edit
// @match        http://mcmods.gigavoid.com/*
// @grant        none
// ==/UserScript==
/* jshint -W097 */
'use strict';

document.querySelector('#ca-edit a').addEventListener('click', function (e) {
    e.preventDefault();
    $.ajax({
        url: 'http://localhost:5909/edit/Cookie_Farm',
        headers: {
            'Api-Endpoint': 'http://mcmods.gigavoid.com/api.php',
            'Token': '+\\'
        }
    });
});
