(function() {
    'use strict';

    angular.module('seeawayApp').filter('numberToDate', numberToDate);

    numberToDate.$inject = [];

    function numberToDate() {
        return function(value) {
            if (value === '') {
                return '';
            } else {
                value = String(value);
                var year = String(value).substr(0, 4),
                    month = String(value).substr(4, 2),
                    day = String(value).substr(6, 2);
                return new Date(year, parseInt(month - 1), day);
            }
        };
    }
})();