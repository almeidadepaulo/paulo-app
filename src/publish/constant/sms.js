(function() {
    'use strict';

    angular.module('seeawayApp').constant('SMS', {
        STATUS_PUBLISH: [{
            id: 1,
            name: 'Cadastrada'
        }, {
            id: 2,
            name: 'Formatada'
        }, {
            id: 3,
            name: 'Filtrada'
        }, {
            id: 4,
            name: 'Enviada'
        }, {
            id: 5,
            name: 'Finalizada'
        }, {
            id: 6,
            name: 'Retida'
        }, {
            id: 7,
            name: 'Cancelada'
        }, {
            id: 10,
            name: 'Acumulada'
        }],
        STATUS_BROKER: [{
            id: 'OK',
            name: 'Mensagem recebida, na fila para envio à operadora'
        }, {
            id: 'OP',
            name: 'Mensagem enviada à operadora'
        }, {
            id: 'CL',
            name: 'Celular confirmou o recebimento'
        }, {
            id: 'ER',
            name: 'Erro de processamento'
        }, {
            id: 'E0',
            name: 'Celular não pertence a nenhuma operadora'
        }, {
            id: 'E4',
            name: 'Mensagem rejeitada pela operadora antes de transmitir. (Número cancelado ou com restrições)'
        }, {
            id: 'E6',
            name: 'Mensagem expirada conforme informação da operadora (expirada após sequencia de tentativas)'
        }, {
            id: 'E7',
            name: 'Mensagem rejeitada por falta de crédito'
        }, {
            id: 'B1',
            name: 'Black List'
        }, {
            id: 'MI',
            name: 'Mensagem inativa'
        }, {
            id: 'QR',
            name: 'Quarentena'
        }, {
            id: 'PC',
            name: 'Percentual'
        }]
    });
})();