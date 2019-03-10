(function() {
    'use strict';

    angular.module('seeawayApp').controller('EmailCodigoFormCtrl', EmailCodigoFormCtrl);

    EmailCodigoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'emailCodigoService', 'getData'];

    function EmailCodigoFormCtrl($state, $stateParams, $mdDialog, emailCodigoService, getData) {

        var vm = this;
        vm.init = init;
        vm.codigo = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        vm.emailCodigoPacote = {
            order: 'ROW',
            limit: 5,
            page: 1,
            selected: [],
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.saveCodigoPacote = saveCodigoPacote;
        vm.removeCodigoPacote = removeCodigoPacote;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';
                vm.getData.codigo.EM055_CD_CODEMAIL = parseInt(vm.getData.codigo.EM055_CD_CODEMAIL);
                vm.codigo = vm.getData.codigo;

                vm.emailCodigoPacote.total = vm.getData.pacotes.length;
                vm.emailCodigoPacote.data = vm.getData.pacotes;
            } else {
                vm.action = 'create';
                vm.codigo.EM055_ID_ATIVO = 0;
                vm.codigo.EM055_TP_CATEG = 0;
            }
        }

        function removeById(event) {
            var confirm = $mdDialog.confirm()
                .title('ATENÇÃO')
                .textContent('Deseja realmente remover este registro?')
                .targetEvent(event)
                .ok('SIM')
                .cancel('NÃO');

            $mdDialog.show(confirm).then(function() {
                emailCodigoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-codigo');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('email-codigo');
        }

        function save() {

            vm.codigo.pacotes = vm.emailCodigoPacote.data;
            if ($stateParams.id) {
                //update
                emailCodigoService.update($stateParams.id, vm.codigo)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('email-codigo');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                emailCodigoService.create(vm.codigo)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('email-codigo');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        // codigo-pacote

        function pagination(page, limit) {
            vm.emailCodigoPacote.data = [];

            if (vm.codigo.EM055_CD_CODEMAIL) {
                vm.emailCodigoPacote.promise = emailCodigoService.getCodigoPacote(vm.codigo.EM055_CD_CODEMAIL)
                    .then(function success(response) {
                        //console.info('success', response);
                        vm.emailCodigo.total = response.recordCount;
                        vm.emailCodigo.data = vm.emailCodigo.data.concat(response.query);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function saveCodigoPacote() {

            var ignorePacotes = '';
            var arrayPacotes = [];
            for (var i = 0; i <= vm.emailCodigoPacote.data.length - 1; i++) {
                arrayPacotes.push(vm.emailCodigoPacote.data[i].EM070_NR_PACOTE);
            }
            ignorePacotes = arrayPacotes.join();
            console.info(ignorePacotes);

            $mdDialog.show({
                locals: { ignorePacotes: ignorePacotes },
                preserveScope: true,
                controller: 'EmailPacoteDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'publish/partial/email-pacote/email-pacote-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(vm.emailCodigoPacote.total, data);
                vm.emailCodigoPacote.total = vm.emailCodigoPacote.total + data.length;
                vm.emailCodigoPacote.data = vm.emailCodigoPacote.data.concat(data);
            });
        }

        function removeCodigoPacote() {
            console.info(vm.emailCodigoPacote.data);

            vm.emailCodigoPacote.selected.forEach(function(item) {
                var index = vm.emailCodigoPacote.data.indexOf(item);

                if (index !== -1) {
                    vm.emailCodigoPacote.data.splice(index, 1);
                }
            });
            vm.emailCodigoPacote.selected = [];
        }
    }
})();