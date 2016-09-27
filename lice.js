/*jslint indent: 2, maxlen: 80, continue: false, unparam: false, node: true */
/* -*- tab-width: 2 -*- */
'use strict';

module.exports = (function () {
  var EX, spdxExceptionsTable = require('./datatable.js');

  EX = function spdxLicenseExceptionInfo(name) {
    name = String(name);
    if (name[0] === '%') { return false; }
    var info = EX.byLowerCaseId[name.toLowerCase()];
    if (!info) { return false; }
    if (!info.idUrlArg) {
      info.idUrlArg = encodeURIComponent(info.id);
      Object.keys(EX.tmpl).forEach(function (key) {
        info[key] = EX.tmpl[key].replace(/%id/g, info.idUrlArg);
      });
    }
    return info;
  };
  EX.spdxVersions = {
    exceptions: spdxExceptionsTable['%%version'],
  };
  EX.tmpl = {
    xcpInfoUrl: 'https://spdx.org/licenses/%id.html',
  };

  (function buildIndex(byLc) {
    byLc = EX.byLowerCaseId = Object.create(null);
    Object.keys(spdxExceptionsTable).forEach(function (key) {
      if (!key) { return; }
      if (key[0] === '%') { return; }
      var lcName = key.toLowerCase(),
        info = Object.assign({ id: key }, spdxExceptionsTable[key]);
      if (byLc[lcName]) { throw new Error('Duplicate key: ' + lcName); }
      byLc[lcName] = info;
      return info;
    });
  }());

  EX.orThrow = function (name) {
    var info = EX(name);
    if (info) { return info; }
    throw new Error('No data available for license exception' +
      JSON.stringify(name));
  };

  return EX;
}());
