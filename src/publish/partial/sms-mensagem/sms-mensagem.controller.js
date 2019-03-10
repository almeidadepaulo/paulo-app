(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsMensagemCtrl', SmsMensagemCtrl);

    SmsMensagemCtrl.$inject = ['config', 'smsMensagemService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function SmsMensagemCtrl(config, smsMensagemService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.codigoDialog = codigoDialog;
        vm.filterCodigoClean = filterCodigoClean;
        vm.smsMensagem = {
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
            vm.smsMensagem.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.smsMensagem.page;
            vm.filter.limit = vm.smsMensagem.limit;

            if (params.reset) {
                vm.smsMensagem.data = [];
            }

            vm.smsMensagem.promise = smsMensagemService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.smsMensagem.total = response.recordCount;
                    vm.smsMensagem.data = vm.smsMensagem.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('sms-mensagem-form');
        }

        function update(id) {
            $state.go('sms-mensagem-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                smsMensagemService.remove(vm.smsMensagem.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.smsMensagem.selected = [];
                        }
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function codigoDialog() {
            $mdDialog.show({
                locals: {},
                preserveScope: true,
                controller: 'SmsCodigoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'publish/partial/sms-codigo/sms-codigo-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(data);
                vm.filter.MG061_CD_CODSMS = data.MG055_CD_CODSMS;
                vm.filter.MG055_DS_CODSMS = data.MG055_DS_CODSMS;
            });
        }

        function filterCodigoClean() {
            vm.filter.MG061_CD_CODSMS = '';
            vm.filter.MG055_DS_CODSMS = '';
        }
    }
})();