(function() {
    'use strict';

    angular.module('seeawayApp').filter('resumoContabilTipo', resumoContabilTipo);

    resumoContabilTipo.$inject = ['RESUMO_CONTABIL'];

    function resumoContabilTipo(RESUMO_CONTABIL) {
        return function(value) {
            value = parseInt(value);
            for (var i = 0; i <= RESUMO_CONTABIL.TIPO.length - 1; i++) {
                if (RESUMO_CONTABIL.TIPO[i].id === value) {
                    return RESUMO_CONTABIL.TIPO[i].name;
                }
            }
            return '?';
        };
    }
})();