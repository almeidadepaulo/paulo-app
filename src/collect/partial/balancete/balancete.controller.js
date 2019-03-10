(function() {
    'use strict';

    angular.module('seeawayApp').controller('BalanceteCtrl', BalanceteCtrl);

    BalanceteCtrl.$inject = ['config', 'balanceteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function BalanceteCtrl(config, balanceteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        // vm.remove = remove;
        vm.balancete = {
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
            vm.filter.CB209_DT_MOVTO = new Date(2012, 7, 29);
            getData({ reset: true });
        }

        function filterClean(model) {
            vm.filter[model] = {};
        }

        function filterDialog(model) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'banco':
                    controller = 'BancoDialogCtrl';
                    templateUrl = 'collect/partial/banco/banco-dialog.html';
                    break;

                case 'agencia':
                    controller = 'AgenciaDialogCtrl';
                    templateUrl = 'collect/partial/agencia/agencia-dialog.html';
                    locals = { banco: vm.filter.banco };
                    break;

                case 'conta':
                    controller = 'ContaDialogCtrl';
                    templateUrl = 'collect/partial/conta/conta-dialog.html';
                    locals = {
                        banco: vm.filter.banco,
                        agencia: vm.filter.agencia
                    };
                    break;

                case 'produto':
                    controller = 'ProdutoDialogCtrl';
                    templateUrl = 'collect/partial/produto/produto-dialog.html';
                    break;
            }

            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: controller,
                controllerAs: 'vm',
                templateUrl: templateUrl,
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                //console.info(data);
                vm.filter[model] = data;

                switch (model) {
                    case 'banco':
                        vm.filter.agencia = {};
                        vm.filter.conta = {};
                        break;

                    case 'agencia':
                        vm.filter.conta = {};
                        break;
                }
            });
        }

        function pagination(page, limit) {
            //vm.balancete.data = [];
            //getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.balancete.page;
            vm.filter.limit = vm.balancete.limit;

            if (params.reset) {
                vm.balancete.data = [];
            }

            vm.balancete.promise = balanceteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.balancete.total = response.recordCount;
                    vm.balancete.data = vm.balancete.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        //function create() {
        //    $state.go('balancete-form');
        //}

        function update(id) {
            $state.go('balancete-form', id);
        }

    }
})();