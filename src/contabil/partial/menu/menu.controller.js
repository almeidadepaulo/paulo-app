(function() {
    'use strict';

    angular.module('seeawayApp').controller('MenuCtrl', MenuCtrl);

    MenuCtrl.$inject = ['config', 'exampleService', '$rootScope', '$scope', '$state', '$stateParams', '$mdDialog'];

    function MenuCtrl(config, exampleService, $rootScope, $scope, $state, $stateParams, $mdDialog) {

        var vm = this;
        vm.menus = {};

        switch ($stateParams.id) {
            case 'contabil':
                vm.menus.menuZone1 = {
                    items: [{
                        title: 'Perfil de usuários',
                        notes: 'Gerencie os usuários',
                        state: 'perfil-usuario'
                    }, {
                        title: 'Conta SICLID',
                        notes: 'Cadastro das Contas contábeis SICLID',
                        state: 'conta-siclid'
                    }, {
                        title: 'Conta COSIF',
                        notes: 'Cadastro das Contas contábeis COSIF',
                        state: 'conta-cosif'
                    }, {
                        title: 'SICLID x COSIF',
                        notes: 'Cadastro de relacionamento das contas contábeis SICLID x COSIF',
                        state: 'siclid-x-cosif'
                    }, {
                        title: 'Ocorrências/Parâmetros',
                        notes: 'Cadastro de parâmetros e divergências entre contas',
                        state: 'ocorrencia'
                    }]
                };

                vm.menus.menuZone2 = {
                    items: [{
                        title: 'Upload',
                        notes: 'Carga de arquivos para conciliação',
                        state: 'upload'
                    }, {
                        title: 'Download',
                        notes: 'Arquivos disponíveis para donwload',
                        state: 'download'
                    }, {
                        title: 'Situação/Medida',
                        notes: 'Medidas a serem tomadas',
                        state: 'situacao-medida'
                    }, {
                        title: 'Lançamentos',
                        notes: 'Aprovar ou reprovar lançamentos',
                        state: 'lancamento'
                    }, {
                        title: 'Gerar capa',
                        notes: 'Gerar arquivo de reconciliação',
                        state: 'capa'
                    }]
                };

                vm.menus.menuZone3 = {
                    items: [{
                        title: 'Conciliador',
                        notes: 'Conciliação entre contas SICLID x COSIF',
                        state: 'conciliador-ocorrencia'
                    }, {
                        title: 'Resumo',
                        notes: 'Resumo da conciliação entre contas SICLID x COSIF',
                        state: 'resumo'
                    }, {
                        title: 'Dashboard',
                        notes: 'Painel de indicadores',
                        state: 'dashboard'
                    }]
                };
                break;
        }

        vm.itemClick = function(event) {
            //event.state = 'example';
            $rootScope.menuCurrent = event;
            $rootScope.$broadcast('seeaway-view-header-update', event);
            $state.go(event.state);
        };
    }
})();