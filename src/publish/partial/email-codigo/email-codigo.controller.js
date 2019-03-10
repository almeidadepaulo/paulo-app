(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailCodigoCtrl', EmailCodigoCtrl);

    EmailCodigoCtrl.$inject = ['config', 'emailCodigoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailCodigoCtrl(config, emailCodigoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.emailCodigo = {
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
            vm.emailCodigo.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailCodigo.page;
            vm.filter.limit = vm.emailCodigo.limit;

            if (params.reset) {
                vm.emailCodigo.data = [];
            }

            vm.emailCodigo.promise = emailCodigoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailCodigo.total = response.recordCount;
                    vm.emailCodigo.data = vm.emailCodigo.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('email-codigo-form');
        }

        function update(id) {
            $state.go('email-codigo-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailCodigoService.remove(vm.emailCodigo.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.emailCodigo.selected = [];
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