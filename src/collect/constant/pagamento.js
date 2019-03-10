(function() {
    'use strict';

    angular.module('seeawayApp').constant('PAGAMENTO', {
        TIPO: [{
            id: 1,
            name: 'A vencer'
        }, {
            id: 2,
            name: 'Vencidos'
        }],
        SITUACAO: [{
            id: 1,
            name: 'Pago'
        }, {
            id: 2,
            name: 'Aberto'
        }]
    });
})();