(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsBlacklistCtrl', SmsBlacklistCtrl);

    SmsBlacklistCtrl.$inject = ['config', 'smsBlacklistService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsBlacklistCtrl(config, smsBlacklistService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.smsBlacklist = {
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
            vm.smsBlacklist.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsBlacklist.page;
            vm.filter.limit = vm.smsBlacklist.limit;

            if (params.reset) {
                vm.smsBlacklist.data = [];
            }

            vm.smsBlacklist.promise = smsBlacklistService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsBlacklist.total = response.recordCount;
                    vm.smsBlacklist.data = vm.smsBlacklist.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('sms-blacklist-form');
        }

        function update(id) {
            $state.go('sms-blacklist-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                smsBlacklistService.remove(vm.smsBlacklist.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.smsBlacklist.selected = [];
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