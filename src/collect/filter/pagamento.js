(function() {
    'use strict';

    angular.module('seeawayApp').filter('pagamentoSituacao', pagamentoSituacao);

    pagamentoSituacao.$inject = ['PAGAMENTO'];

    function pagamentoSituacao(PAGAMENTO) {
        return function(value) {
            value = parseInt(value);
            for (var i = 0; i <= PAGAMENTO.SITUACAO.length - 1; i++) {
                if (PAGAMENTO.SITUACAO[i].id === value) {
                    return PAGAMENTO.SITUACAO[i].name;
                }
            }
            return '?';
        };
    }
})();