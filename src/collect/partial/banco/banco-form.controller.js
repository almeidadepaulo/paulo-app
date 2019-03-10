(function() {
    'use strict';

    angular.module('seeawayApp').controller('BancoFormCtrl', BancoFormCtrl);

    BancoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'bancoService', 'getData'];

    function BancoFormCtrl($state, $stateParams, $mdDialog, bancoService, getData) {

        var vm = this;
        vm.init = init;
        vm.banco = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.cepSearch = cepSearch;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB250_NR_CEP = String(vm.getData.CB250_NR_CEP).trim();
                vm.getData.CB250_CD_COMPSC = parseInt(vm.getData.CB250_CD_COMPSC);
                vm.banco = vm.getData;
            } else {
                vm.action = 'create';

                // defaults
                vm.banco.CB250_NR_CEP = '';
                vm.banco.CB250_NM_END = '';
                vm.banco.CB250_NR_END = '';
                vm.banco.CB250_DS_COMPL = '';
                vm.banco.CB250_NM_BAIRRO = '';
                vm.banco.CB250_SG_ESTADO = '';
                vm.banco.CB250_NM_CIDADE = '';
                vm.banco.CB250_DS_COMPL = '';
                vm.banco.CB250_NR_NOSNUM = '';
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
                bancoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('banco');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('banco');
        }

        function save() {

            if ($stateParams.id) {
                //update
                bancoService.update($stateParams.id, vm.banco)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('banco');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                bancoService.create(vm.banco)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('banco');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.banco.CB250_NM_END = event.data.logradouro;
            vm.banco.CB250_NM_BAIRRO = event.data.bairro;
            vm.banco.CB250_NM_CIDADE = event.data.localidade;
            vm.banco.CB250_SG_ESTADO = event.data.uf;
        }
    }
})();