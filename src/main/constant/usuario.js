(function() {
    'use strict';

    angular.module('seeawayApp').constant('USUARIO', {
        STATUS: [{
            id: 1,
            name: 'Ativo'
        }, {
            id: 0,
            name: 'Inativo'
        }]
    });
})();