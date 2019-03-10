(function() {
    'use strict';

    angular.module('seeawayApp').controller('CarteiraCtrl', CarteiraCtrl);

    CarteiraCtrl.$inject = ['config', 'carteiraService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function CarteiraCtrl(config, carteiraService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.carteira = {
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
            vm.carteira.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.carteira.page;
            vm.filter.limit = vm.carteira.limit;

            if (params.reset) {
                vm.carteira.data = [];
            }

            vm.carteira.promise = carteiraService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.carteira.total = response.recordCount;
                    vm.carteira.data = vm.carteira.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('carteira-form');
        }

        function update(id) {
            $state.go('carteira-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                carteiraService.remove(vm.carteira.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.carteira.selected = [];
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