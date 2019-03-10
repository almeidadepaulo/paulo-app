(function() {
    'use strict';

    angular.module('seeawayApp').controller('FluxoVencimentoCtrl', FluxoVencimentoCtrl);

    FluxoVencimentoCtrl.$inject = ['config', 'fluxoVencimentoService', '$rootScope', '$scope', '$state',
        '$mdDialog', '$filter'
    ];

    function FluxoVencimentoCtrl(config, fluxoVencimentoService, $rootScope, $scope, $state,
        $mdDialog, $filter) {

        var vm = this;
        vm.init = init;
        vm.getData = getData;
        vm.filter = {};
        vm.filter.months = moment.months();
        vm.filterClean = filterClean;
        vm.filterDialog = filterDialog;
        vm.fluxoVencimento = {
            limit: 10,
            page: 1,
            selected: [],
            order: '',
            data: [],
            pagination: pagination,
            total: 0
        };
        vm.caixaChange = caixaChange;
        vm.tipoRelatorioChange = tipoRelatorioChange;

        // $on
        // https://docs.angularjs.org/api/ng/type/$rootScope.Scope
        $scope.$on('broadcastTest', function() {
            console.info('broadcastTest!');
            //getData();
        });


        function init() {
            vm.filter.caixa = 'diario';
            vm.filter.visao = 'geral';
            vm.filter.ano = vm.filter.ano || moment().year();
            vm.filter.mes = vm.filter.mes || moment().month();
            vm.filter.CB208_DT_MOVTO = {
                startDate: moment().utc().startOf('month'),
                endDate: moment().utc().endOf('day')
            };

            getData({ reset: true });
        }

        function caixaChange() {
            getData({ reset: true });
        }

        function tipoRelatorioChange() {
            getData({ reset: true });
        }

        function filterClean(model) {
            vm.filter[model] = {};

            switch (model) {
                case 'banco':
                    vm.filter['agencia'] = {};
                    vm.filter['conta'] = {};
                    break;

                case 'agencia':
                    vm.filter['conta'] = {};
                    break;
            }
        }

        function filterDialog(model, item) {

            var controller = '';
            var templateUrl = '';
            var locals = {};

            switch (model) {
                case 'banco':
                    controller = 'BancoDialogCtrl';
                    templateUrl = 'collect/partial/banco/banco-dialog.html';
                    break;

                case 'carteira':
                    controller = 'CarteiraDialogCtrl';
                    templateUrl = 'collect/partial/carteira/carteira-dialog.html';
                    break;

                case 'produto':
                    controller = 'ProdutoDialogCtrl';
                    templateUrl = 'collect/partial/produto/produto-dialog.html';
                    break;

                case 'analitico':
                    if (vm.filter.caixa === 'diario') {
                        vm.filter.CB210_DT_VCTO = moment($filter('numberToDate')(item.CB208_DT_MOVTO));
                        item.title = 'Títulos com vencimento em ' + moment($filter('numberToDate')(item.CB208_DT_MOVTO)).format('DD/MM/YYYY');
                    } else {
                        vm.filter.CB210_DT_VCTO = '';
                        item.title = 'Títulos com vencimento em ' + moment(new Date(vm.filter.ano, vm.filter.mes, 1)).format('MM/YYYY');
                    }
                    vm.filter.fluxoVencimento = true;
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
                vm.filter[model] = data;

                switch (model) {
                    case 'banco':
                        vm.filter.agencia = {};
                        vm.filter.conta = {};
                        break;

                    case 'agencia':
                        vm.filter.conta = {};
                        break;
                }
            });
        }

        function pagination(page, limit) {
            vm.fluxoVencimento.data = [];
            getData();
        }

        function getData(params) {

            params = params || {};

            vm.filter = vm.filter || {};
            vm.filter.page = vm.fluxoVencimento.page;
            vm.filter.limit = vm.fluxoVencimento.limit;

            if (params.reset) {
                vm.filter.page = 1;
                vm.fluxoVencimento.data = [];
            }

            vm.fluxoVencimento.promise = fluxoVencimentoService.get(vm.filter)
                .then(function success(response) {
                    //console.info('success', response);
                    vm.fluxoVencimento.total = response.recordCount;
                    vm.fluxoVencimento.data = vm.fluxoVencimento.data.concat(response.query);
                }, function error(response) {
                    console.error('error', response);
                });
        }
    }
})();