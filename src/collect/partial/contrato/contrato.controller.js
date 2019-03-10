(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContratoCtrl', ContratoCtrl);

    ContratoCtrl.$inject = ['config', 'contratoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function ContratoCtrl(config, contratoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        // vm.create = create;
        vm.update = update;
        // vm.remove = remove;
        vm.contrato = {
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
            vm.contrato.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.contrato.page;
            vm.filter.limit = vm.contrato.limit;

            if (params.reset) {
                vm.contrato.data = [];
            }

            vm.contrato.promise = contratoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.contrato.total = response.recordCount;
                    vm.contrato.data = vm.contrato.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        //function create() {
        //    $state.go('contrato-form');
        //}

        function update(id) {
            $state.go('contrato-form', id);
        }

        //function remove() {

        //  var confirm = $mdDialog.confirm()
        //      .title('ATENÇÃO')
        //      .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
        //      .targetEvent(event)
        //      .ok('SIM')
        //      .cancel('NÃO');

        //  $mdDialog.show(confirm).then(function() {
        //      contratoService.remove(vm.contrato.selected)
        //          .then(function success(response) {
        //              if (response.success) {
        //                  $('.md-selected').remove();
        //                  vm.contrato.selected = [];
        //              }
        //         }, function error(response) {
        //              console.error('error', response);
        //          });
        //  }, function() {
        // cancel
        //  });
        //}
    }
})();