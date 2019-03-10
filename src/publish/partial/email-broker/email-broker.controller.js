(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailBrokerCtrl', EmailBrokerCtrl);

    EmailBrokerCtrl.$inject = ['config', 'emailBrokerService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailBrokerCtrl(config, emailBrokerService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.emailBroker = {
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
            vm.emailBroker.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailBroker.page;
            vm.filter.limit = vm.emailBroker.limit;

            if (params.reset) {
                vm.emailBroker.data = [];
            }

            vm.emailBroker.promise = emailBrokerService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailBroker.total = response.recordCount;
                    vm.emailBroker.data = vm.emailBroker.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('email-broker-form');
        }

        function update(id) {
            $state.go('email-broker-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailBrokerService.remove(vm.emailBroker.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.emailBroker.selected = [];
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