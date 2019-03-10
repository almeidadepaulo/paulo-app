(function() {
    'use strict';

    angular.module('seeawayApp').controller('ResumoCtrl', ResumoCtrl);

    ResumoCtrl.$inject = ['config', 'resumoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ResumoCtrl(config, resumoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        // vm.remove = remove;
        vm.resumo = {
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
            vm.filter.CB214_DT_MOVTO = {
                startDate: new Date(2000, 0, 1),
                endDate: moment().endOf('day')
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
            //vm.resumo.data = [];
            //getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.resumo.page;
            vm.filter.limit = vm.resumo.limit;

            if (params.reset) {
                vm.resumo.data = [];
            }

            vm.resumo.promise = resumoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.resumo.total = response.recordCount;
                    vm.resumo.data = vm.resumo.data.concat(response.query);
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