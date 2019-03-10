(function() {
    'use strict';

    angular.module('seeawayApp').controller('NotificacaoFormCtrl', NotificacaoFormCtrl);

    NotificacaoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'notificacaoService', 'getData', 'cepService'];

    function NotificacaoFormCtrl($state, $stateParams, $mdDialog, notificacaoService, getData, cepService) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.notificacao = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.tipoChange = tipoChange;
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;


        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB261_ID_ANEXO = parseInt(vm.getData.CB261_ID_ANEXO);
                vm.getData.CB261_ID_STATUS = parseInt(vm.getData.CB261_ID_STATUS);
                vm.notificacao = vm.getData;
            } else {
                vm.action = 'create';
                vm.notificacao.CB261_DS_COMPL = '';
                vm.notificacao.CB261_ID_STATUS = 0;
                vm.notificacao.CB261_ID_ANEXO = 0;
            }
        }

        function tipoChange() {
            vm.notificacao.CB261_NM_MSG = '';
            vm.notificacao.CB261_CD_MSG = '';
        }

        function filterClean(model) {
            vm.filter[model] = {};
        }

        function filterDialog(model) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'mensagem':
                    if (parseInt(vm.notificacao.CB261_CD_PUBLIC) === 1) {
                        controller = 'SmsCodigoDialogCtrl';
                        templateUrl = 'publish/partial/sms-codigo/sms-codigo-dialog.html';
                    } else {
                        controller = 'EmailCodigoDialogCtrl';
                        templateUrl = 'publish/partial/email-codigo/email-codigo-dialog.html';
                    }
                    break;
            }

            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: controller,
                controllerAs: 'vm',
                templateUrl: templateUrl,
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                vm.notificacao.CB261_NM_MSG = data.name;
                vm.notificacao.CB261_CD_MSG = data.id;
            });
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                notificacaoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('notificacao');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('notificacao');
        }

        function save() {

            if ($stateParams.id) {
                //update
                notificacaoService.update($stateParams.id, vm.notificacao)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('notificacao');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                notificacaoService.create(vm.notificacao)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('notificacao');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();