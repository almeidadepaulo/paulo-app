(function() {
    'use strict';

    angular.module('seeawayApp').controller('CarteiraSelecaoCtrl', CarteiraSelecaoCtrl);

    CarteiraSelecaoCtrl.$inject = ['config', 'carteiraSelecaoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function CarteiraSelecaoCtrl(config, carteiraSelecaoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.filter = {};
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.carteiraSelecao = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.tipoRelatorioChange = tipoRelatorioChange;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            vm.filter.visao = 'geral';
            vm.filter.CB209_DT_MOVTO = {
                //startDate: moment().utc().add(-1, 'days').startOf('day'),
                //endDate: moment().utc().endOf('day')
                startDate: new Date(2000, 0, 1),
                endDate: new Date()
            };
            getData({ reset: true });
        }

        function tipoRelatorioChange() {
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

                case 'carteira':
                    controller = 'CarteiraDialogCtrl';
                    templateUrl = 'collect/partial/carteira/carteira-dialog.html';
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
            vm.carteiraSelecao.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.carteiraSelecao.page;
            vm.filter.limit = vm.carteiraSelecao.limit;

            if (params.reset) {
                vm.filter.page = 1;
                vm.carteiraSelecao.data = [];
            }

            vm.carteiraSelecao.promise = carteiraSelecaoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.carteiraSelecao.total = response.recordCount;
                    vm.carteiraSelecao.data = vm.carteiraSelecao.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }
    }
})();