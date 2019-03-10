(function() {
    'use strict';

    angular.module('seeawayApp').controller('AnaliseCadastralCtrl', AnaliseCadastralCtrl);

    AnaliseCadastralCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'entradaService', 'stringUtil'];

    function AnaliseCadastralCtrl($state, $stateParams, $mdDialog, entradaService, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            vm.receita = {};
            vm.receita.items = [{
                name: 'CNPJ',
                enabled: true
            }, {
                name: 'Razão Social',
                enabled: true
            }, {
                name: 'Nome Fantasia',
                enabled: true
            }, {
                name: 'Simples Nacional',
                enabled: true
            }, {
                name: 'Natureza',
                enabled: false
            }, {
                name: 'Situação Cadastral',
                enabled: true
            }, {
                name: 'Atividade Principal',
                enabled: true
            }, {
                name: 'Atividade Secundária',
                enabled: false
            }, {
                name: 'QSA',
                enabled: false
            }];

            vm.jucesp = {};
            vm.jucesp.items = [{
                name: 'CNPJ',
                enabled: true
            }, {
                name: 'NIRE',
                enabled: true
            }, {
                name: 'Tipo Empresa',
                enabled: true
            }];

            vm.sintegra = {};
            vm.sintegra.items = [{
                name: 'CNPJ',
                enabled: true
            }, {
                name: 'Inscrição Estadual',
                enabled: true
            }, {
                name: 'Tipo Empresa',
                enabled: true
            }, {
                name: 'Atividade',
                enabled: true
            }, {
                name: 'Situação',
                enabled: true
            }, {
                name: 'Regime',
                enabled: true
            }];

            vm.serasa = {};
            vm.serasa.items = [{
                name: 'Serasa - Identificação',
                enabled: true
            }];

            vm.boaVista = {};
            vm.boaVista.items = [{
                name: 'Preciso',
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