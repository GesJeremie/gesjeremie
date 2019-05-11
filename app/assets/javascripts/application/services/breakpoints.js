(function () {
    'use strict';

    var BREAKPOINTS = window.app.config.breakpoints,

        isSmallerThan = function (breakpoint) {
            return $(window).width() < BREAKPOINTS[breakpoint];
        };

    window.app.services.breakpoints = {
        isSmallerThan: isSmallerThan
    };
}());
