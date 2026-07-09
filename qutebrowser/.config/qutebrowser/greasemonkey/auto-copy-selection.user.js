// ==UserScript==
// @name qutebrowser auto-copy selection
// @description Copy selected text to the clipboard when a selection is made.
// @match http://*/*
// @match https://*/*
// @match file:///*
// @grant GM_setClipboard
// @run-at document-end
// ==/UserScript==

(function () {
    "use strict";

    let lastCopied = "";

    function activeElementSelection() {
        const element = document.activeElement;

        if (!element || element.type === "password") {
            return "";
        }

        if (typeof element.selectionStart !== "number" ||
            typeof element.selectionEnd !== "number" ||
            element.selectionEnd <= element.selectionStart) {
            return "";
        }

        return element.value.slice(element.selectionStart, element.selectionEnd);
    }

    function pageSelection() {
        const selection = window.getSelection();
        return selection ? selection.toString() : "";
    }

    function copySelection() {
        const text = activeElementSelection() || pageSelection();

        if (!text) {
            lastCopied = "";
            return;
        }

        if (text === lastCopied) {
            return;
        }

        lastCopied = text;
        GM_setClipboard(text);
    }

    document.addEventListener("mouseup", copySelection, true);
    document.addEventListener("keyup", copySelection, true);
    document.addEventListener("touchend", copySelection, true);
})();
