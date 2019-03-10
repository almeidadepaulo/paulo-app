(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsBrokerCtrl', SmsBrokerCtrl);

    SmsBrokerCtrl.$inject = ['config', 'smsBrokerService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsBrokerCtrl(config, smsBrokerService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.smsBroker = {
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
            vm.smsBroker.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsBroker.page;
            vm.filter.limit = vm.smsBroker.limit;

            if (params.reset) {
                vm.smsBroker.data = [];
            }

            vm.smsBroker.promise = smsBrokerService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsBroker.total = response.recordCount;
                    vm.smsBroker.data = vm.smsBroker.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('sms-broker-form');
        }

        function update(id) {
            $state.go('sms-broker-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                smsBrokerService.remove(vm.smsBroker.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.smsBroker.selected = [];
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