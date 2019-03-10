(function() {
    'use strict';

    angular.module('seeawayApp').controller('SmsCodigoFormCtrl', SmsCodigoFormCtrl);

    SmsCodigoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'smsCodigoService', 'getData'];

    function SmsCodigoFormCtrl($state, $stateParams, $mdDialog, smsCodigoService, getData) {

        var vm = this;
        vm.init = init;
        vm.codigo = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        vm.smsCodigoPacote = {
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
                vm.getData.codigo.MG055_CD_CODSMS = parseInt(vm.getData.codigo.MG055_CD_CODSMS);
                vm.codigo = vm.getData.codigo;

                vm.smsCodigoPacote.total = vm.getData.pacotes.length;
                vm.smsCodigoPacote.data = vm.getData.pacotes;
            } else {
                vm.action = 'create';
                vm.codigo.MG055_ID_ATIVO = 0;
                vm.codigo.MG055_TP_CATEG = 0;
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
                smsCodigoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-codigo');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('sms-codigo');
        }

        function save() {

            vm.codigo.pacotes = vm.smsCodigoPacote.data;
            if ($stateParams.id) {
                //update
                smsCodigoService.update($stateParams.id, vm.codigo)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('sms-codigo');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                smsCodigoService.create(vm.codigo)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('sms-codigo');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        // codigo-pacote

        function pagination(page, limit) {
            vm.smsCodigoPacote.data = [];

            if (vm.codigo.MG055_CD_CODSMS) {
                vm.smsCodigoPacote.promise = smsCodigoService.getCodigoPacote(vm.codigo.MG055_CD_CODSMS)
                    .then(function success(response) {
                        //console.info('success', response);
                        vm.smsCodigo.total = response.recordCount;
                        vm.smsCodigo.data = vm.smsCodigo.data.concat(response.query);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function saveCodigoPacote() {

            var ignorePacotes = '';
            var arrayPacotes = [];
            for (var i = 0; i <= vm.smsCodigoPacote.data.length - 1; i++) {
                arrayPacotes.push(vm.smsCodigoPacote.data[i].MG070_NR_PACOTE);
            }
            ignorePacotes = arrayPacotes.join();
            console.info(ignorePacotes);

            $mdDialog.show({
                locals: { ignorePacotes: ignorePacotes },
                preserveScope: true,
                controller: 'SmsPacoteDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'publish/partial/sms-pacote/sms-pacote-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: true
            }).then(function(data) {
                console.info(vm.smsCodigoPacote.total, data);
                vm.smsCodigoPacote.total = vm.smsCodigoPacote.total + data.length;
                vm.smsCodigoPacote.data = vm.smsCodigoPacote.data.concat(data);
            });
        }

        function removeCodigoPacote() {
            console.info(vm.smsCodigoPacote.data);

            vm.smsCodigoPacote.selected.forEach(function(item) {
                var index = vm.smsCodigoPacote.data.indexOf(item);

                if (index !== -1) {
                    vm.smsCodigoPacote.data.splice(index, 1);
                }
            });
            vm.smsCodigoPacote.selected = [];
        }
    }
})();