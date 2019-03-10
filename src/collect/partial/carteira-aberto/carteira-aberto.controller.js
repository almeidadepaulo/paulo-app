(function() {
    'use strict';

    angular.module('seeawayApp').controller('CarteiraAbertoCtrl', CarteiraAbertoCtrl);

    CarteiraAbertoCtrl.$inject = ['config', 'pagamentoService', '$rootScope', '$scope', '$state', '$mdDialog', 'PAGAMENTO'];

    function CarteiraAbertoCtrl(config, pagamentoService, $rootScope, $scope, $state, $mdDialog, PAGAMENTO) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.filter = {};
        vm.TIPO = PAGAMENTO.TIPO;
        vm.pagamento = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.update = update;
        vm.showPdf = showPdf;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });

        function init() {
            vm.filter.TIPO = PAGAMENTO.TIPO[0].id;
            vm.filter.CB210_NR_CPFCNPJ = '';
            // NÃO PAGO
            vm.filter.CB210_ID_SITPAG = 2;
            getData({ reset: true });
        }

        function pagination(page, limit) {
            vm.pagamento.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.pagamento.page;
            vm.filter.limit = vm.pagamento.limit;

            if (params.reset) {
                vm.pagamento.data = [];
            }

            vm.pagamento.promise = pagamentoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.pagamento.total = response.recordCount;
                    vm.pagamento.data = vm.pagamento.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function update(id) {
            $state.go('carteira-aberto-form', id);
        }

        function showPdf(item) {
            var locals = {
                items: vm.pagamento.selected
            };
            $mdDialog.show({
                locals: locals,
                preserveScope: true,
                controller: 'CarteiraAbertoPdfDialogCtrl',
                controllerAs: 'vm',
                templateUrl: 'collect/partial/pagamento/pagamento-pdf-dialog.html',
                parent: angular.element(document.body),
                //targetEvent: event,
                clickOutsideToClose: false
            }).then(function(data) {
                //console.info(data);
            });
        }
    }
})();