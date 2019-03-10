(function() {
    'use strict';

    angular.module('seeawayApp').controller('ExtratoCtrl', ExtratoCtrl);

    ExtratoCtrl.$inject = ['config', 'extratoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ExtratoCtrl(config, extratoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.filter = {};
        vm.filter.months = moment.months();
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.extrato = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.caixaChange = caixaChange;
        vm.tipoRelatorioChange = tipoRelatorioChange;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });


        function init() {
            vm.filter.ano = vm.filter.ano || moment().year();
            vm.filter.mes = vm.filter.mes || moment().month();

            //getData({ reset: true });
        }

        function caixaChange() {
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
            vm.extrato.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.extrato.page;
            vm.filter.limit = vm.extrato.limit;

            if (params.reset) {
                vm.filter.page = 1;
                vm.extrato.data = [];
            }

            vm.extrato.promise = extratoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.extrato.total = response.recordCount;
                    vm.extrato.data = vm.extrato.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }
    }
})();