(function() {
    'use strict';

    angular.module('seeawayApp').controller('AgenciaFormCtrl', AgenciaFormCtrl);

    AgenciaFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'agenciaService', 'getData'];

    function AgenciaFormCtrl($state, $stateParams, $mdDialog, agenciaService, getData) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.agencia = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;
        vm.cepSearch = cepSearch;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB251_CD_COMPSC = parseInt(vm.getData.CB251_CD_COMPSC);
                vm.getData.CB251_NR_AGENC = parseInt(vm.getData.CB251_NR_AGENC);
                vm.getData.CB251_NR_DGAGEN = parseInt(vm.getData.CB251_NR_DGAGEN);
                vm.getData.CB251_NR_CEP = String(vm.getData.CB251_NR_CEP).trim();

                vm.agencia = vm.getData;

                vm.filter.banco = {
                    id: vm.getData.CB250_CD_COMPSC,
                    name: vm.getData.CB250_NM_BANCO
                };
            } else {
                vm.action = 'create';

                // defaults
                vm.agencia.CB251_NR_CEP = '';
                vm.agencia.CB251_NM_END = '';
                vm.agencia.CB251_NR_END = '';
                vm.agencia.CB251_DS_COMPL = '';
                vm.agencia.CB251_NM_BAIRRO = '';
                vm.agencia.CB251_SG_ESTADO = '';
                vm.agencia.CB251_NM_CIDADE = '';
                vm.agencia.CB251_DS_COMPL = '';
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
                agenciaService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('agencia');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('agencia');
        }

        function save() {

            if ($stateParams.id) {
                //update
                agenciaService.update($stateParams.id, vm.agencia)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('agencia');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                agenciaService.create(vm.agencia)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('agencia');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.agencia.CB251_NM_END = event.data.logradouro;
            vm.agencia.CB251_NM_BAIRRO = event.data.bairro;
            vm.agencia.CB251_NM_CIDADE = event.data.localidade;
            vm.agencia.CB251_SG_ESTADO = event.data.uf;
        }

        function filterClean(model) {
            vm.filter[model] = {};

            switch (model) {
                case 'banco':
                    vm.filter['agencia'] = {};
                    break;
            }
        }

        function filterDialog(model) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'carteira':
                    controller = 'CarteiraDialogCtrl';
                    templateUrl = 'collect/partial/carteira/carteira-dialog.html';
                    break;

                case 'banco':
                    controller = 'BancoDialogCtrl';
                    templateUrl = 'collect/partial/banco/banco-dialog.html';
                    break;

                case 'agencia':
                    vm.filter.banco.contaState = true;
                    controller = 'AgenciaDialogCtrl';
                    templateUrl = 'collect/partial/agencia/agencia-dialog.html';
                    locals = { banco: vm.filter.banco };
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
                vm.filter[model] = data;

                switch (model) {
                    case 'banco':
                        vm.agencia.CB251_CD_COMPSC = data.id;
                        break;
                }
            });
        }
    }
})();