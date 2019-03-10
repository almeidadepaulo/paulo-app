(function() {
    'use strict';

    angular.module('seeawayApp').constant('RESUMO_CONTABIL', {
        TIPO: [{
            id: 1,
            name: 'Saldo anterior'
        }, {
            id: 2,
            name: 'Entrada'
        }, {
            id: 3,
            name: 'Liquidado'
        }, {
            id: 4,
            name: 'Baixado'
        }, {
            id: 5,
            name: 'Pagamento por acordo'
        }, {
            id: 6,
            name: 'Cancelamento de operação'
        }, {
            id: 7,
            name: 'Baixa financeira'
        }]
    });
})();