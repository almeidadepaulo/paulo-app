(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContatoCtrl', ContatoCtrl);

    ContatoCtrl.$inject = ['config', 'contatoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContatoCtrl(config, contatoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.contato = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.contato.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.contato.page;
            vm.filter.limit = vm.contato.limit;

            if (params.reset) {
                vm.contato.data = [];
            }

            vm.contato.promise = contatoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.contato.total = response.recordCount;
                    vm.contato.data = vm.contato.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('contato-form');
        }

        function update(id) {
            $state.go('contato-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                contatoService.remove(vm.contato.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.contato.selected = [];
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }
    }
})();