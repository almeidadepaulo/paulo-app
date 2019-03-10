(function() {
    'use strict';

    angular.module('seeawayApp').controller('EntradaFormCtrl', EntradaFormCtrl);

    EntradaFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'entradaService', 'stringUtil'];

    function EntradaFormCtrl($state, $stateParams, $mdDialog, entradaService, stringUtil) {

        var vm = this;
        vm.init = init;
        vm.entrada = {};
        vm.cancel = cancel;
        vm.save = save;
        vm.filter = {};
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.cepSearch = cepSearch;
        vm.parcela = {};
        vm.parcelaAdd = parcelaAdd;
        vm.parcelaRemove = parcelaRemove;
        vm.contratoParcela = {
            limit: 5,
            page: 1,
            selected: [],
            order: '',
            data: [],
            //pagination: pagination,
            total: 0
        };

        function init() {
            vm.parcela.parcelaNumero = 1;
            vm.parcela.parcelaValor = 0;
            if ($stateParams.id) {
                vm.action = 'update';
            } else {
                vm.action = 'create';
            }
        }

        function filterClean(model) {
            vm.filter[model] = {};
        }

        function filterDialog(model) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'sacado':
                    controller = 'SacadoDialogCtrl';
                    templateUrl = 'collect/partial/sacado/sacado-dialog.html';
                    break;

                case 'produto':
                    controller = 'ProdutoDialogCtrl';
                    templateUrl = 'collect/partial/produto/produto-dialog.html';
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
                //console.info('data', data);                
            });
        }

        function cepSearch(event) {
            //console.info('cepSearch', event);
            vm.contrato.CB213_DS_LOGRAD = event.data.logradouro;
            vm.contrato.CB213_DS_BAIRRO = event.data.bairro;
            vm.contrato.CB213_NM_CIDADE = event.data.localidade;
            vm.contrato.CB213_SG_UF = event.data.uf;
        }

        function parcelaAdd() {
            vm.contratoParcela.data.push({
                parcelaNumero: vm.parcela.parcelaNumero,
                parcelaValor: vm.parcela.parcelaValor
            });

            //console.info(vm.contratoParcela.data.length);
            vm.parcela.parcelaNumero = vm.contratoParcela.data.length + 1;

            vm.contratoParcela.data.sort(function(a, b) {
                return (a.parcelaNumero > b.parcelaNumero) ? 1 : ((b.parcelaNumero > a.parcelaNumero) ? -1 : 0);
            });
        }

        function parcelaRemove() {
            var array = vm.contratoParcela.selected;
            for (var i = array.length - 1; i >= 0; i--) {
                vm.contratoParcela.data.splice(i, 1);
            }
            vm.contratoParcela.selected = [];

            if (vm.contratoParcela.data.length === 0) {
                vm.parcela.parcelaNumero = 1;
            }
            //vm.parcela.parcelaNumero = vm.contratoParcela.data.length;

            vm.contratoParcela.data.sort(function(a, b) {
                a.parcelaNumero = parseInt(a.parcelaNumero);
                b.parcelaNumero = parseInt(b.parcelaNumero);
                return (a.parcelaNumero > b.parcelaNumero) ? 1 : ((b.parcelaNumero > a.parcelaNumero) ? -1 : 0);
            });
        }

        function cancel() {
            $state.go('menu', { id: 'entrada' });
        }

        function save() {
            var data = {};

            // sendEntrada
            entradaService.create(data)
                .then(function success(response) {
                    //console.info('success', response);

                    vm.filter = {};
                    vm.contrato = {};
                    vm.parcela = {};
                    vm.parcela.parcelaNumero = 1;
                    vm.parcela.parcelaValor = 0;
                    vm.contratoParcela.data = [];
                    vm.contratoParcela.selected = [];

                    $mdDialog.show(
                        $mdDialog.alert()
                        .clickOutsideToClose(true)
                        .title('Aviso')
                        .textContent('Entrada enviada com sucesso!')
                        .ariaLabel('Aviso')
                        .ok('Fechar')
                    );
                }, function error(response) {
                    console.error('error', response);
                });

        }
    }
})();