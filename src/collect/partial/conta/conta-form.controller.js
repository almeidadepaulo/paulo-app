(function() {
    'use strict';

    angular.module('seeawayApp').controller('ContaFormCtrl', ContaFormCtrl);

    ContaFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'contaService', 'getData', 'cepService'];

    function ContaFormCtrl($state, $stateParams, $mdDialog, contaService, getData, cepService) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.cepSearch = cepSearch;
        vm.conta = {};
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB260_NR_CONTA = parseInt(vm.getData.CB260_NR_CONTA);
                vm.getData.CB260_NR_DGCONT = parseInt(vm.getData.CB260_NR_DGCONT);
                vm.getData.CB260_NR_NOSNUM = parseInt(vm.getData.CB260_NR_NOSNUM);
                vm.getData.CB260_NR_CEP = String(vm.getData.CB260_NR_CEP).trim();
                vm.filter.carteira = {
                    id: vm.getData.CB256_CD_CART,
                    name: vm.getData.CB256_DS_CART
                };
                vm.filter.banco = {
                    id: vm.getData.CB260_CD_COMPSC,
                    name: vm.getData.CB250_NM_BANCO
                };
                vm.filter.agencia = {
                    id: vm.getData.CB260_NR_AGENC,
                    name: vm.getData.CB251_NR_AGENC + ' - ' + vm.getData.CB251_NM_AGENC
                };
                vm.getData.CB260_ID_INTECC = parseInt(vm.getData.CB260_ID_INTECC);
                vm.conta = vm.getData;
            } else {
                vm.action = 'create';
                // defaults
                vm.conta.CB260_DS_COMPL = '';
                vm.conta.CB260_ID_INTECC = 2;
            }
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.conta.CB260_NM_END = event.data.logradouro;
            vm.conta.CB260_NM_BAIRRO = event.data.bairro;
            vm.conta.CB260_NM_CIDADE = event.data.localidade;
            vm.conta.CB260_SG_ESTADO = event.data.uf;
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
            locals.contaState = true;

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
                    case 'carteira':
                        vm.conta.CB260_CD_CART = data.id;
                        vm.conta.CB256_DS_CART = data.name;
                        break;

                    case 'banco':
                        vm.conta.CB260_CD_COMPSC = data.id;
                        vm.CB260_NR_AGENC = null;
                        vm.filter.agencia = {};
                        break;

                    case 'agencia':
                        vm.conta.CB260_NR_AGENC = data.id;
                        vm.conta.CB260_NR_DGAGCT = data.item.CB251_NR_DGAGEN;
                        vm.conta.CB260_NR_CPFCNPJ = data.item.CB251_NR_CNPJ;
                        break;
                }
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
                contaService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('conta');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('conta');
        }

        function save() {

            if ($stateParams.id) {
                //update
                contaService.update($stateParams.id, vm.conta)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('conta');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                contaService.create(vm.conta)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('conta');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();