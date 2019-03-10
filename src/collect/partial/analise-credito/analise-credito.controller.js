(function() {
    'use strict';

    angular.module('seeawayApp').controller('AnaliseCreditoCtrl', AnaliseCreditoCtrl);

    AnaliseCreditoCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'entradaService', 'stringUtil'];

    function AnaliseCreditoCtrl($state, $stateParams, $mdDialog, entradaService, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            vm.serasa = {};
            vm.serasa.items = [{
                name: 'Concentre',
                enabled: true
            }, {
                name: 'Agrupe',
                enabled: true
            }, {
                name: 'Relato',
                enabled: true
            }, {
                name: 'CCF',
                enabled: true
            }, {
                name: 'Protesto',
                enabled: true
            }, {
                name: 'Credit Rating',
                enabled: true
            }, {
                name: 'Achei - Recheque',
                enabled: true
            }, {
                name: 'Crédit Bureau',
                enabled: true
            }, {
                name: 'Limite de crédito PJ',
                enabled: true
            }, {
                name: 'Faturamento presumido',
                enabled: true
            }];

            vm.boaVista = {};
            vm.boaVista.items = [{
                name: 'Accerto PJ',
                enabled: true
            }, {
                name: 'ACSP',
                enabled: true
            }];
        }

        function save() {
            $state.go('menu');
        }

        function cancel() {
            $state.go('menu');
        }

    }
})();