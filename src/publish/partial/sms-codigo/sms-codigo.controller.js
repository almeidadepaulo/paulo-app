(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsCodigoCtrl', SmsCodigoCtrl);

    SmsCodigoCtrl.$inject = ['config', 'smsCodigoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsCodigoCtrl(config, smsCodigoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.smsCodigo = {
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
            vm.smsCodigo.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsCodigo.page;
            vm.filter.limit = vm.smsCodigo.limit;

            if (params.reset) {
                vm.smsCodigo.data = [];
            }

            vm.smsCodigo.promise = smsCodigoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsCodigo.total = response.recordCount;
                    vm.smsCodigo.data = vm.smsCodigo.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('sms-codigo-form');
        }

        function update(id) {
            $state.go('sms-codigo-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                smsCodigoService.remove(vm.smsCodigo.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.smsCodigo.selected = [];
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