(function() {
    'use strict';

    angular.module('seeawayApp').constant('NOTIFICACAO', {
        STATUS: [{
            id: 0,
            name: 'Não Ativo'
        }, {
            id: 1,
            name: 'Ativo'
        }],
        TIPO: [{
            id: 1,
            name: 'E-mail'
        }, {
            id: 2,
            name: 'SMS'
        }, {
            id: 3,
            name: 'Correspondência'
        }],
        ACAO: [{
            id: 1,
            name: 'Inicial'
        }, {
            id: 2,
            name: 'Final'
        }, {
            id: 3,
            name: 'A vencer'
        }, {
            id: 4,
            name: 'Vencido'
        }],
        ANEXO: [{
            id: 0,
            name: 'Não'
        }, {
            id: 1,
            name: 'Sim'
        }]
    });
})();