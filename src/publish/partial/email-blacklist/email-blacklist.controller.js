(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailBlacklistCtrl', EmailBlacklistCtrl);

    EmailBlacklistCtrl.$inject = ['config', 'emailBlacklistService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailBlacklistCtrl(config, emailBlacklistService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.emailBlacklist = {
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
            vm.emailBlacklist.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailBlacklist.page;
            vm.filter.limit = vm.emailBlacklist.limit;

            if (params.reset) {
                vm.emailBlacklist.data = [];
            }

            vm.emailBlacklist.promise = emailBlacklistService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailBlacklist.total = response.recordCount;
                    vm.emailBlacklist.data = vm.emailBlacklist.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('email-blacklist-form');
        }

        function update(id) {
            $state.go('email-blacklist-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailBlacklistService.remove(vm.emailBlacklist.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.emailBlacklist.selected = [];
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