(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsPacoteCtrl', SmsPacoteCtrl);

    SmsPacoteCtrl.$inject = ['config', 'smsPacoteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsPacoteCtrl(config, smsPacoteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.smsPacote = {
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
            vm.smsPacote.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsPacote.page;
            vm.filter.limit = vm.smsPacote.limit;

            if (params.reset) {
                vm.smsPacote.data = [];
            }

            vm.smsPacote.promise = smsPacoteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsPacote.total = response.recordCount;
                    vm.smsPacote.data = vm.smsPacote.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('sms-pacote-form');
        }

        function update(id) {
            $state.go('sms-pacote-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                smsPacoteService.remove(vm.smsPacote.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.smsPacote.selected = [];
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