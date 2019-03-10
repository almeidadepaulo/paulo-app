(function() {
    'use strict';

    angular.module('seeawayApp').controller('PagamentoFormCtrl', PagamentoFormCtrl);

    PagamentoFormCtrl.$inject = ['$state', '$stateParams', '$mdDialog', 'pagamentoService', 'getData', '$filter',
        'PAGAMENTO'
    ];

    function PagamentoFormCtrl($state, $stateParams, $mdDialog, pagamentoService, getData, $filter,
        PAGAMENTO) {

        var vm = this;
        vm.init = init;
        vm.pagamento = {};
        vm.situacao = PAGAMENTO.SITUACAO;
        vm.getData = getData;
        vm.removeById = removeById;
        vm.cancel = cancel;
        vm.save = save;

        function init() {
            if ($stateParams.id) {
                vm.action = 'update';

                vm.getData.CB210_NR_CPFCNPJ = $filter('padLeft')(vm.getData.CB210_NR_CPFCNPJ, '00000000000');
                vm.getData.CB203_DT_EMISS = moment($filter('numberToDate')(vm.getData.CB203_DT_EMISS)).format('DD/MM/YYYY');
                vm.getData.CB210_DT_VCTO = moment($filter('numberToDate')(vm.getData.CB210_DT_VCTO)).format('DD/MM/YYYY');
                vm.pagamento = vm.getData;
            } else {
                vm.action = 'create';
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
                pagamentoService.removeById($stateParams.id)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('pagamento');
                    }, function error(response) {
                        console.error('error', response);
                    });
            }, function() {
                // cancel
            });
        }

        function cancel() {
            $state.go('pagamento');
        }

        function save() {

            if ($stateParams.id) {
                //update
                pagamentoService.update($stateParams.id, vm.pagamento)
                    .then(function success(response) {
                        console.info('success', response);
                        $state.go('pagamento');
                    }, function error(response) {
                        console.error('error', response);
                    });
            } else {
                // create
                pagamentoService.create(vm.pagamento)
                    .then(function success(response) {
                        if (response.success) {
                            $state.go('pagamento');
                        }
                        console.info('success', response);
                    }, function error(response) {
                        console.error('error', response);
                    });
            }
        }
    }
})();