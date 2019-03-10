(function() {
    'use strict';

    angular.module('seeawayApp').controller('MenuCtrl', MenuCtrl);

    MenuCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function MenuCtrl(config, exampleService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.menus = {};

        vm.menus.menuZone1 = {
            items: [{
                title: 'Parâmetros',
                notes: 'Defina parâmetros para conta corrente',
                state: 'parametro'
            }, {
                title: 'Eventos',
                notes: 'Cadastro de eventos',
                state: 'evento'
            }, {
                title: 'Fornecedor',
                notes: 'Cadastro de fornecedor',
                state: 'fornecedor'
            }]
        };

        vm.menus.menuZone2 = {
            items: [{
                title: 'Extrato',
                notes: 'Extrato e lançamentos',
                state: 'extrato'
            }, {
                title: 'Upload',
                notes: 'Envie arquivos',
                state: 'upload'
            }]
        };

        vm.menus.menuZone3 = {
            items: [{
                title: 'Processamento de arquivos',
                notes: 'Veja os status dos arquivos processados',
                state: 'upload-log'
            }]
        };

        vm.itemClick = function(event) {
            //event.state = 'example';
            $state.go(event.state);
        };
    }
})();