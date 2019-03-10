(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailPacoteCtrl', EmailPacoteCtrl);

    EmailPacoteCtrl.$inject = ['config', 'emailPacoteService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailPacoteCtrl(config, emailPacoteService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.emailPacote = {
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
            vm.emailPacote.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailPacote.page;
            vm.filter.limit = vm.emailPacote.limit;

            if (params.reset) {
                vm.emailPacote.data = [];
            }

            vm.emailPacote.promise = emailPacoteService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailPacote.total = response.recordCount;
                    vm.emailPacote.data = vm.emailPacote.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('email-pacote-form');
        }

        function update(id) {
            $state.go('email-pacote-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailPacoteService.remove(vm.emailPacote.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.emailPacote.selected = [];
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