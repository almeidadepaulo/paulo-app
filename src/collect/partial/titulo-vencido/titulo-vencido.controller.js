(function() {
    'use strict';

    angular.module('seeawayApp').controller('TituloVencidoCtrl', TituloVencidoCtrl);

    TituloVencidoCtrl.$inject = ['config', 'tituloVencidoService', '$rootScope', '$scope', '$state', '$mdDialog'];

    function TituloVencidoCtrl(config, tituloVencidoService, $rootScope, $scope, $state, $mdDialog) {

        var vm = this;
        vm.init = init;
        vm.filter = {};
        vm.filterDialog = filterDialog;
        vm.getData = getData;
        vm.tituloVencido = {
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
            //vm.tituloVencido.data = [];
            //getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.tituloVencido.page;
            vm.filter.limit = vm.tituloVencido.limit;

            if (params.reset) {
                vm.tituloVencido.data = [];
            }

            vm.tituloVencido.promise = tituloVencidoService.get(vm.filter)
                .then(function success(response) {
                    console.info('success', response);
                    vm.tituloVencido.total = response.recordCount;
                    vm.tituloVencido.data = vm.tituloVencido.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }

        function filterDialog(model, item) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'analitico':
                    item.title = 'Título vencidos - ' + item.POSICAO;
                    // PAGO
                    vm.filter.CB210_ID_SITPAG = 2;
                    vm.filter.ORDEM = item.ORDEM;
                    locals.filter = vm.filter;
                    locals.item = item;
                    controller = 'PagamentoAnaliticoDialogCtrl';
                    templateUrl = 'collect/partial/pagamento-relatorio/pagamento-analitico-dialog.html';
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
                //console.info(data);
            });
        }
    }
})();