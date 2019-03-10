(function() {
    'use strict';

    angular.module('seeawayApp').controller('TarifaBancariaCtrl', TarifaBancariaCtrl);

    TarifaBancariaCtrl.$inject = ['config', 'tarifaBancariaService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function TarifaBancariaCtrl(config, tarifaBancariaService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        // vm.remove = remove;
        vm.tarifaBancaria = {
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
            vm.filter.CB209_DT_MOVTO = {
                startDate: new Date(2000, 0, 1),
                endDate: moment().utc().endOf('day')
            };
            getData({ reset: true });
        }

        function filterClean(model) {
            vm.filter[model] = {};

            switch (model) {
                case 'banco':
                    vm.filter['agencia'] = {};
                    vm.filter['conta'] = {};
                    break;

                case 'agencia':
                    vm.filter['conta'] = {};
                    break;
            }
        }

        function filterDialog(model) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'produto':
                    controller = 'ProdutoDialogCtrl';
                    templateUrl = 'collect/partial/produto/produto-dialog.html';
                    break;

                case 'carteira':
                    controller = 'CarteiraDialogCtrl';
                    templateUrl = 'collect/partial/carteira/carteira-dialog.html';
                    break;

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
                console.info(data);
                vm.filter[model] = data;
            });
        }

        function pagination(page, limit) {
            //vm.tarifaBancaria.data = [];
            //getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.tarifaBancaria.page;
            vm.filter.limit = vm.tarifaBancaria.limit;

            if (params.reset) {
                vm.tarifaBancaria.data = [];
            }

            vm.tarifaBancaria.promise = tarifaBancariaService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.tarifaBancaria.total = response.recordCount;
                    vm.tarifaBancaria.data = vm.tarifaBancaria.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        //function create() {
        //    $state.go('tarifabancaria-form');
        //}

        function update(id) {
            $state.go('tarifabancaria-form', id);
        }

    }
})();