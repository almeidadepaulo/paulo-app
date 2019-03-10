(function() {
    'use strict';

    angular.module('seeawayApp').controller('NotificacaoCtrl', NotificacaoCtrl);

    NotificacaoCtrl.$inject = ['config', 'notificacaoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function NotificacaoCtrl(config, notificacaoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.notificacao = {
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
            vm.notificacao.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.notificacao.page;
            vm.filter.limit = vm.notificacao.limit;

            if (params.reset) {
                vm.notificacao.data = [];
            }

            vm.notificacao.promise = notificacaoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.notificacao.total = response.recordCount;
                    vm.notificacao.data = vm.notificacao.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('notificacao-form');
        }

        function update(id) {
            $state.go('notificacao-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                notificacaoService.remove(vm.notificacao.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.notificacao.selected = [];
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