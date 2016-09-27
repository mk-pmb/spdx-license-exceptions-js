#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-
SELFFILE="$(readlink -m "$BASH_SOURCE")"; SELFPATH="$(dirname "$SELFFILE")"


function update_exceptions () {
  cd "$SELFPATH" || return $?

  local SRC_URL='https://spdx.org/licenses/exceptions-index.html'
  local CACHE_FN="$HOME/.cache/spdx_org/exceptions.$(date +%F).html"
  mkdir -p "$(dirname "$CACHE_FN")" || return $?
  if [ ! -s "$CACHE_FN" ]; then
    wget -O "$CACHE_FN".part -c "$SRC_URL" || return $?
    mv --verbose --no-clobber --no-target-directory \
      -- "$CACHE_FN"{.part,} || return $?
  fi

  local SPACE_HTML="$(<"$CACHE_FN" tr -s '\t \r\n' ' ')"
  local TBLVER='<strong>Version:</strong> \S+</p> <h2>License Exceptions</h2>'
  TBLVER="$(<<<"$SPACE_HTML" grep -oPe "$TBLVER" | grep -oPe '\S+</p>' -m 1 \
    | sed -nre 's~^([0-9]+\.[0-9]+)</p>$~\1~p')"
  [ -n "$TBLVER" ] || return 5$(echo "E: unable to find table version" >&2)

  local DEST_FN='datatable.js'
  grep -Fe '=' -m 1 -B 9002 -- "$DEST_FN" >"$DEST_FN".new || return $?
  <<<"$SPACE_HTML" sed -re 's~</?tr>~\n&~g' | sed -nre '
    s~^<tr> <td><a [^<>]*\bhref="[^"<>]*/([^"<>]+-exception(-[^"<>]+|)|$\
      )\.html"[^<>]*>([^<>]+)</a>.*$~  "\1": { "name": "\3" },~ip
    ' >>"$DEST_FN".new || return $?
  <<<'  "%%version": "'"$TBLVER"'"' tee -a -- "$DEST_FN".new || return $?
  echo '};' >>"$DEST_FN".new || return $?
  mv --verbose -- "$DEST_FN"{.new,} || return $?
  return 0
}










[ "$1" == --lib ] && return 0; update_exceptions "$@"; exit $?
