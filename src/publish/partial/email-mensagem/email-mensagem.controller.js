(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailMensagemCtrl', EmailMensagemCtrl);

    EmailMensagemCtrl.$inject = ['config', 'emailMensagemService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function EmailMensagemCtrl(config, emailMensagemService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.create = create;
        vm.update = update;
        vm.remove = remove;
        vm.codigoDialog = codigoDialog;
        vm.filterCodigoClean = filterCodigoClean;
        vm.emailMensagem = {
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
            vm.emailMensagem.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.emailMensagem.page;
            vm.filter.limit = vm.emailMensagem.limit;

            if (params.reset) {
                vm.emailMensagem.data = [];
            }

            vm.emailMensagem.promise = emailMensagemService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.emailMensagem.total = response.recordCount;
                    vm.emailMensagem.data = vm.emailMensagem.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function create() {
            $state.go('email-mensagem-form');
        }

        function update(id) {
            $state.go('email-mensagem-form', id);
        }

        function remove() {

            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover o(s) item(ns) selecionado(s)?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailMensagemService.remove(vm.emailMensagem.selected)
                    .then(function success(response) {
                        if (response.success) {
                            $('.md-selected').remove();
                            vm.emailMensagem.selected = [];
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
                controller: 'EmailCodigoDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'publish/partial/email-codigo/email-codigo-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(data);
                vm.filter.EM061_CD_CODEMAIL = data.EM055_CD_CODEMAIL;
                vm.filter.EM055_DS_CODEMAIL = data.EM055_DS_CODEMAIL;
            });
        }

        function filterCodigoClean() {
            vm.filter.EM061_CD_CODEMAIL = '';
            vm.filter.EM055_DS_CODEMAIL = '';
        }
    }
})();